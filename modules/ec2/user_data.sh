#!/bin/bash
apt-get update -y
apt-get install -y apache2 php mysql-client

# Create a simple e-commerce application
cat > /var/www/html/index.php << 'EOF'
<?php
$servername = "${db_endpoint}";
$username = "${db_username}";
$password = "${db_password}";
$dbname = "${db_name}";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Create products table if not exists
$sql = "CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)";

if ($conn->query($sql) === TRUE) {
    // Insert sample products
    $insert_sql = "INSERT IGNORE INTO products (name, price) VALUES 
        ('Laptop', 999.99),
        ('Smartphone', 699.99),
        ('Headphones', 199.99),
        ('Tablet', 499.99)";
    $conn->query($insert_sql);
}

// Get products
$result = $conn->query("SELECT * FROM products");

echo "<!DOCTYPE html>
<html>
<head>
    <title>E-Commerce Store</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .product { border: 1px solid #ddd; padding: 20px; margin: 10px; border-radius: 5px; }
        .header { background: #f4f4f4; padding: 20px; text-align: center; }
    </style>
</head>
<body>
    <div class='header'>
        <h1>Welcome to Our E-Commerce Store!</h1>
        <p>Environment: ${environment}</p>
        <p>Server: " . gethostname() . "</p>
    </div>
    <h2>Our Products</h2>";

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        echo "<div class='product'>
                <h3>" . $row["name"] . "</h3>
                <p>Price: $" . $row["price"] . "</p>
              </div>";
    }
} else {
    echo "<p>No products found</p>";
}

echo "</body></html>";

$conn->close();
?>
EOF

systemctl enable apache2
systemctl start apache2