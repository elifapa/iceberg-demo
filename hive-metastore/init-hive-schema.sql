-- Initialize Hive Metastore Database
-- This script ensures the database is ready for Hive schema initialization

-- Grant necessary permissions
GRANT ALL PRIVILEGES ON DATABASE hive_metastore TO hive;
GRANT ALL PRIVILEGES ON SCHEMA public TO hive;

-- Create necessary extensions if they don't exist
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Set default privileges for future objects
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO hive;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO hive;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON FUNCTIONS TO hive;