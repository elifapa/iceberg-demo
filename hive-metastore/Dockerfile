FROM apache/hive:4.0.0

# Install curl (requires apt, and apt updates)
USER root
RUN apt-get update && \
    apt-get install -y net-tools curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Download PostgreSQL JDBC driver
RUN curl -L -o /opt/hive/lib/postgresql-42.7.1.jar \
  https://repo1.maven.org/maven2/org/postgresql/postgresql/42.7.1/postgresql-42.7.1.jar

# Switch back to hive user
USER hive
# Run Hive Metastore service only
CMD ["hive", "--service", "metastore"]
