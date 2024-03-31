# Defines a resource for creating a Google Cloud SQL database instance.
resource "google_sql_database_instance" "instance" {
  # Sets the name of the database instance, incorporating the app name from Terraform variables for uniqueness.
  name = "${var.app_name}-db-instance"

  # Specifies the region where the database instance will be located, using a variable for flexibility.
  region = var.region

  # Defines the version of the database. Here, it's set to use PostgreSQL 14.
  database_version = "POSTGRES_14"

  # Disables deletion protection, allowing the database to be deleted without additional safeguards. Use with caution.
  deletion_protection = false

  # Configuration settings for the database instance.
  settings {
    # Sets the machine type (tier) for the database. "db-f1-micro" is a small, economical option suitable for light applications.
    tier = "db-f1-micro"

    # Sets a specific database flag, in this case, the maximum number of connections allowed, which is set to 50.
    database_flags {
      name  = "max_connections"
      value = "50"
    }
  }
}

# Defines a resource for creating a specific database within the SQL instance.
resource "google_sql_database" "database" {
  # The name of the database, incorporating the app name for uniqueness.
  name = "${var.app_name}-db"

  # Links this database to the previously defined SQL database instance.
  instance = google_sql_database_instance.instance.name
}

# Defines a resource for creating a user for the SQL database.
resource "google_sql_user" "database-user" {
  # The name of the database user, taken from a Terraform variable.
  name = var.database_user

  # Associates this user with the previously defined SQL database instance.
  instance = google_sql_database_instance.instance.name

  # Sets the password for the database user, using a secure input variable.
  password = var.database_password
}
