# 概要
- vook_web_v3のインフラを作成するコード

# 手順

- 検証環境を作成するためのIAMを作成 & クレデンシャルとキー情報を移動する。
  - 録画: https://drive.google.com/file/d/1UhMwayWxjdp6ymMVP5nYPG01qVmCuO69/view?usp=drive_link
- AWS CLI インストールする。
  - 以下のコマンドでバージョンが表示されていればOK
```
aws --version
```
- AWS CLI 認証情報の設定
```
aws configure # ターミナルで実行。
AWS Access Key ID [None]: 上記で作成した [アクセスキー ID]
AWS Secret Access Key [None]: 上記で作成した [シークレットアクセスキー]
Default region name [None]: ap-northeast-1
Default output format [None]: 何も入力せずにEnterキーを押下
```
- terraform.tfvarsを作成する。
```
touch terraform.tfvars
```
- terraform.tfvarsを開き、アクセスキーと、シークレットキーを設定する。
```
code terraform.tfvars
```
```
access_key = "<アクセスキー>"
secret_key = "<シークレットキー>"
```
- Terraformをインストールする。
  - https://developer.hashicorp.com/terraform/downloads
  - 以下のコマンドでバージョンが表示されていればOK
```
terraform -v
```
- vook_infra_v1をクライアントPCの任意の場所にcloneする。
```
git clone git@github.com:atsushimemet/vook_infra_v1.git
```
- 以下手順を実行する。録画参照のこと
  - terraform initでワークスペースを初期化
    - Terraform has been successfully initialized!が出力されればOK。
  - terraform validateでtfファイルの構文チェック
    - Success! The configuration is valid.が出力されればOK。
  - terraform planで実行計画を作成
    - 実行は任意
  - terraform applyでリソースを作成
    - Enter a value: が表示されたらyesを押下
  - terraform showで作成したリソースを確認
  - 録画: https://drive.google.com/file/d/1Uivm_tmH2gRkMVGkqF548-pNG1NpV7Gs/view?usp=drive_link
- terraformで作成したEC2にSSH接続する。録画参照のこと
  - 録画: https://drive.google.com/file/d/1k3-fOpigkZZx318op1yOMYzDKFWNO_Xf/view?usp=drive_link

# 参考

- https://kacfg.com/terraform-vpc-ec2/
- https://github.com/atsushimemet/vook_web_v3/issues/5
- error
  - https://github.com/atsushimemet/tf_tutorial/blob/main/variables.tf
  - https://stackoverflow.com/questions/59583711/error-launching-source-instance-unauthorizedoperation-you-are-not-authorized-t
  - https://qiita.com/Hikosaburou/items/1d3765d85d5398e3763f
- https://zenn.dev/suganuma/articles/fe14451aeda28f
