# 作成したEC2のパブリックIPアドレスを出力
output "ec2_global_ips" {
  value = "${aws_instance.vook-rails-web.*.public_ip}"
}