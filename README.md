# Iceberg Demo with Trino, Hive Metastore, PostgreSQL, and MinIO

This project demonstrates an OTF (Open Table Format) stack using the following components:

- **Iceberg**: Table format layer on top of the object store. Acts as a bridge between data lake (Minio) and the query engine (Trino)
    * Iceberg defines how table data and metadata are stored in the data lake (in this case, in MinIO).
    * Unlike Hive tables, which store just basic metadata in the Hive Metastore and organize data loosely, Iceberg manages schema evolution, partitioning, and versioning in a much more reliable way.


- **Trino**: A distributed SQL query engine, utilised with Iceberg connector in this project.  
    * Trino uses the Iceberg connector to read/write Iceberg tables stored in the MinIO object store.
    * Trino connects to Iceberg tables via the Hive Metastore.
    
- **Hive Metastore**: A metadata store for managing table schemas and locations.
- **PostgreSQL**: Used as the backend database for the Hive Metastore.
- **MinIO**: An S3-compatible object storage for storing Iceberg table data.

## What happens behind the scenes?

The following happens behind the scenes when you run a `CREATE TABLE` SQL in Trino:  

1. Trino parses the query and delegates to the Iceberg connector.  
2. The Iceberg connector:  

    * Writes table metadata in Iceberg format to s3a://warehouse/... (MinIO).
    * Registers the table in the Hive Metastore.

When querying the table with `SELECT` sql:  

1. The Iceberg connector fetches metadata from the warehouse directory.
2. It uses Iceberg’s metadata files (manifest lists, snapshots) to locate data files.
3. Trino reads the data files (e.g., Parquet) from MinIO.

## Prerequisites

- Docker and Docker Compose installed on your system.

## Getting Started

1. Clone this repository:
   ```bash
   git clone https://github.com/your-repo/iceberg-demo.git
   cd iceberg-demo