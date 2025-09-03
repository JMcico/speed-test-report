### **Network Speed Test and Monitoring**

This project provides a complete solution for automatically testing network speed and storing the results in an InfluxDB database for visualization. The setup is designed for easy deployment and management, ensuring consistent data collection and clear monitoring.

-----

### **Prerequisites**

Before you begin, ensure you have the following installed:

  * **Docker**: For running InfluxDB and Grafana containers.
  * **Git**: For cloning the repository.
  * **Bash**: For executing the setup scripts.

-----

### **Project Setup**

The project setup is broken into three simple steps to prepare your environment, database, and application.

#### **Step 1: Install Python Environment**

The `setup_python.sh` script handles the installation of Python and sets up a dedicated virtual environment to manage project dependencies.

```bash
# Execute the Python setup script
./setup_python.sh
```

This script will install Python and create a `venv` folder in your project directory.

#### **Step 2: Install and Initialize InfluxDB**

The `setup_influxdb.sh` script uses Docker to install and initialize the InfluxDB database. It will also create the necessary organization, bucket, and API token for your project.

```bash
# Execute the InfluxDB setup script
./setup_influxdb.sh
```

#### **Step 3: Configure and Run the Application**

Once the environment is ready, you need to configure the application by editing the `.env` file located in the `speeder_poc` directory.

```bash
# Navigate to the application directory
cd speeder_poc/
```

Open the `.env` file with a text editor and update the parameters with your specific values.

**`.env` file format:**

```ini
INFLUXDB_URL=http://localhost:8086
INFLUXDB_TOKEN=my-super-secret-token
INFLUXDB_ORG=speeder
INFLUXDB_BUCKET=speeder
BRANCH=HO
```

  * **`INFLUXDB_URL`**: The URL of your InfluxDB instance (e.g., `http://localhost:8086`).
  * **`INFLUXDB_TOKEN`**: The API token generated during the InfluxDB initialization.
  * **`INFLUXDB_ORG`**: The organization name for your data.
  * **`INFLUXDB_BUCKET`**: The bucket where your speed test data will be stored.
  * **`BRANCH`**: The identifier for the location where the script is running (e.g., a specific branch name like "HO" or "London").

After updating the `.env` file, you can run the main script to start sending data to InfluxDB.

```bash
# Run the speed test script
python main.py
```

This will perform a single speed test and write the results to your InfluxDB bucket. For continuous monitoring, it is recommended to automate this script using a scheduling tool like **`cron`**.

-----

### **Visualization with Grafana**

After data is successfully sent to InfluxDB, you can use **Grafana** to create powerful dashboards and visualize your network performance.

  * Connect your Grafana instance to the InfluxDB database as a data source.
  * Use **Flux queries** to retrieve the network speed data.
  * Create customizable graphs and dashboards to monitor network performance across all your branches.
