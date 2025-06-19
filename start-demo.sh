#!/bin/bash

echo "🚀 Starting Iceberg + Trino + MinIO Demo Stack (Docker Compose v2)..."

# Validate required files exist
required_files=(
    "docker-compose.yml"
    "hive-metastore/hive-site.xml"
    "hive-metastore/core-site.xml"
    "hive-metastore/init-hive-schema.sql"
    "trino/etc/config.properties"
    "trino/etc/node.properties"
    "trino/etc/jvm.config"
    "trino/etc/log.properties"
    "trino/etc/catalog/iceberg.properties"
)

echo "🔍 Checking required files..."
for file in "${required_files[@]}"; do
    if [[ ! -f "$file" ]]; then
        echo "❌ Missing file: $file"
        echo "Please create all configuration files first."
        exit 1
    fi
done

echo "✅ All configuration files found!"

# Docker compose down
echo "🐳 Stopping Docker Compose stack..."
docker-compose down

# Start the stack
echo "🐳 Starting Docker Compose stack..."
docker-compose up -d

echo "⏳ Waiting for services to be ready..."

# Wait for PostgreSQL
echo "📊 Waiting for PostgreSQL..."
until docker-compose exec -T postgres pg_isready -U hive -d hive_metastore > /dev/null 2>&1; do
    echo "  PostgreSQL not ready, waiting 2s..."
    sleep 2
done
echo "✅ PostgreSQL is ready!"

# Wait for MinIO
echo "🗄️  Waiting for MinIO..."
until curl -f http://localhost:9000/minio/health/live > /dev/null 2>&1; do
    echo "  MinIO not ready, waiting 2s..."
    sleep 2
done
echo "✅ MinIO is ready!"

# Wait for Hive Metastore
echo "🏪 Waiting for Hive Metastore..."
until docker-compose exec -T hive-metastore netstat -an | grep 9083 | grep LISTEN > /dev/null 2>&1; do
    echo "  Hive Metastore not ready, waiting 3s..."
    sleep 3
done
echo "✅ Hive Metastore is ready!"

# Wait for Trino
echo "⚡ Waiting for Trino..."
until curl -f http://localhost:8080/v1/info > /dev/null 2>&1; do
    echo "  Trino not ready, waiting 3s..."
    sleep 3
done
echo "✅ Trino is ready!"

echo ""
echo "🎉 Stack is ready!"
echo ""
echo "🌊 Services running:"
echo "  - MinIO Console:    http://localhost:9001 (admin/password)"
echo "  - MinIO API:        http://localhost:9000"
echo "  - Trino Web UI:     http://localhost:8080"
echo "  - PostgreSQL:       localhost:5432 (hive/hive)"
echo "  - Hive Metastore:   localhost:9083"
echo ""
echo "🔗 Connect to Trino CLI:"
echo "  docker-compose exec trino trino"
echo ""
echo "📊 Test Iceberg setup:"
echo "  docker-compose exec trino trino --execute \"SHOW CATALOGS;\""
echo "  docker-compose exec trino trino --execute \"SHOW SCHEMAS FROM iceberg;\""
echo ""
echo "📋 Sample Iceberg commands:"
echo "  CREATE SCHEMA iceberg.demo;"
echo "  CREATE TABLE iceberg.demo.sample_table (id bigint, name varchar, created_at timestamp);"
echo "  INSERT INTO iceberg.demo.sample_table VALUES (1, 'Alice', current_timestamp);"
echo "  SELECT * FROM iceberg.demo.sample_table;"
echo ""
echo "🔧 Debug commands:"
echo "  docker-compose logs trino"
echo "  docker-compose logs hive-metastore"
echo ""
echo "🛑 To stop the stack:"
echo "  docker-compose down"
echo "  docker-compose down -v  # (removes volumes too)"