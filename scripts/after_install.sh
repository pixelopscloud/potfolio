#!/bin/bash
echo "Starting post-deployment tasks..."

# Set proper permissions
cd /home/ec2-user/deploy
chmod -R 755 .

# Start your application (example for Java web app)
# cd /home/ec2-user/deploy
# nohup java -jar your-app.jar > app.log 2>&1 &

echo "Post-deployment completed successfully"
echo "Application deployed at: /home/ec2-user/deploy"
