output "aws_ec2_ip_address"{
    value = aws_instance.example.public_ip
}