# 作成したEC2のパブリックIPアドレスを出力
output "ec2_global_ips" {
  value = "${aws_instance.vook-rails-2-web.*.public_ip}"
}