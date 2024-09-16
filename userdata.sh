#!/bin/bash
apt update
apt install -y apache2

# Install the Azure CLI
apt install -y azure-cli

# Create a simple HTML file with the portfolio content and display the image
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
  <title>My Portfolio</title>
  <style>
    /* Add animation and styling for the text */
    @keyframes colorChange {
      0% { color: red; }
      50% { color: green; }
      100% { color: blue; }
    }
    h1 {
      animation: colorChange 2s infinite;
    }
    /* Add some styling for the lists */
    ul {
      font-family: Arial, sans-serif;
      font-size: 16px;
      color: #333;
    }
    li {
      margin: 5px 0;
    }
  </style>
</head>
<body>
  <h1>Terraform Project Server 1</h1>
  <h2>Welcome To My Terraform Project</h2>
  <p>Components used in project</p>
  <ul>
    <li>Virtual Network</li>
    <li>Subnets</li>
    <li>Network interfaces (NICs)</li>
    <li>Virtual machines</li>
    <li>Private key</li>
    <li>Public load balancer</li>
    <li>Userdata scripts</li>
    <li>Identity management</li>
    <li>Network security group</li>
    <li>Public ips</li>
  </ul>
  
</body>
</html>
EOF

# Start Apache and enable it on boot
systemctl start apache2
systemctl enable apache2