.. image:: ./doc/001samune.png

=====================================================================
OCI Block Volume のアタッチメントを整理する
=====================================================================

=====================================================================
デプロイ - Terraform -
=====================================================================

作業環境 - ローカル -
=====================================================================
* 64bit版 Windows 11 Pro
* Visual Studio Code 1.96.2 (Default Terminal: Git Bash)
* Git 2.47.1.windows.2
* Terraform v1.13.5
* oci cli 3.71.0
* Python 3.12.0

フォルダ構成
=====================================================================
* `こちら <./folder.md>`_ を参照

前提条件
=====================================================================
* テナンシに対し ``manage all-resources`` を付与した IAM グループに所属する IAM ユーザーが作成されていること
* 実作業は *envs* フォルダ配下の各環境フォルダで実施すること
* 以下コマンドを実行し、*ADMIN* プロファイルを作成していること (デフォルトリージョンは *ap-tokyo-1* )

.. code-block:: bash

  oci session authenticate

事前作業(1)
=====================================================================
1. 各種モジュールインストール
---------------------------------------------------------------------
* `GitHub <https://github.com/tyskJ/common-environment-setup>`_ を参照

事前作業(2)
=====================================================================
1. *tfstate* 用バケット作成
---------------------------------------------------------------------
.. code-block:: bash

  oci os bucket create \
  --compartment-id <デプロイ先コンパートメントID> \
  --name terraform-working \
  --profile ADMIN --auth security_token

.. note::

  * バケット名は、テナンシかつリージョン内で一意であれば作成できます


実作業 - ローカル -
=====================================================================
1. *backend* 用設定ファイル作成
---------------------------------------------------------------------

.. note::

  * *envs* フォルダ配下に作成すること

.. code-block:: bash

  cat <<EOF > config.oci.tfbackend
  bucket = "terraform-working"
  namespace = "テナンシに一意に付与されたネームスペース"
  auth = "SecurityToken"
  config_file_profile = "ADMIN"
  region = "ap-tokyo-1"
  EOF

2. 変数ファイル作成
---------------------------------------------------------------------

.. note::

  * *envs* フォルダ配下に作成すること

.. code-block:: bash

  cat <<EOF > oci.auto.tfvars
  tenancy_id = "テナンシID"
  compartment_id = "デプロイ先コンパートメントID"
  source_ip = "接続元IPアドレス(CIDR形式)"
  EOF


3. *Terraform* 初期化
---------------------------------------------------------------------
.. code-block:: bash

  terraform init -backend-config="./config.oci.tfbackend"

4. 事前確認
---------------------------------------------------------------------
.. code-block:: bash

  terraform plan

5. デプロイ
---------------------------------------------------------------------
.. code-block:: bash

  terraform apply --auto-approve

後片付け - ローカル -
=====================================================================
1. 環境削除
---------------------------------------------------------------------
.. code-block:: bash

  terraform destroy --auto-approve

2. *tfstate* 用S3バケット削除
---------------------------------------------------------------------
.. code-block:: bash

  oci os bucket delete \
  --bucket-name terraform-working \
  --force --empty \
  --profile ADMIN --auth security_token

参考資料
=====================================================================
リファレンス
---------------------------------------------------------------------
* `terraform_data resource reference <https://developer.hashicorp.com/terraform/language/resources/terraform-data>`_
* `Backend block configuration overview <https://developer.hashicorp.com/terraform/language/backend#partial-configuration>`_
* `All Image Families - Oracle Cloud Infrastructure Documentation/Images <https://docs.oracle.com/en-us/iaas/images/>`_
* `ブロック・ボリュームへの接続 - Oracle Cloud Infrastructureドキュメント <https://docs.oracle.com/ja-jp/iaas/Content/Block/Tasks/connectingtoavolume.htm>`_
* `iSCSIでアタッチされたブロック・ボリュームへの接続 - Oracle Cloud Infrastructureドキュメント <https://docs.oracle.com/ja-jp/iaas/Content/Block/Tasks/connectingtoavolume_topic-Connecting_to_iSCSIAttached_Volumes.htm>`_
* `自動的に再起動するためのLinux iSCSIサービスの更新 - Oracle Cloud Infrastructureドキュメント <https://docs.oracle.com/ja-jp/iaas/Content/Compute/Tasks/updatingiscsidservice.htm>`_
* `ブロック・ボリューム管理プラグインの有効化 - Oracle Cloud Infrastructureドキュメント <https://docs.oracle.com/ja-jp/iaas/Content/Block/Tasks/enablingblockvolumemanagementplugin.htm>`_
* `タグおよびタグ・ネームスペースの概念 - Oracle Cloud Infrastructureドキュメント <https://docs.oracle.com/ja-jp/iaas/Content/Tagging/Tasks/managingtagsandtagnamespaces.htm#Who>`_

ブログ
---------------------------------------------------------------------
* `Terraformでmoduleを使わずに複数環境を構築する - Zenn <https://zenn.dev/smartround_dev/articles/5e20fa7223f0fd>`_
* `Terraformでmoduleを使わずに複数環境を構築して感じた利点 - SpeakerDeck <https://speakerdeck.com/shonansurvivors/building-multiple-environments-without-using-modules-in-terraform>`_
* `個人的備忘録：Terraformディレクトリ整理の個人メモ（ファイル分割編） - Qiita <https://qiita.com/free-honda/items/5484328d5b52326ed87e>`_
* `Terraformの auto.tfvars を使うと、環境管理がずっと楽になる話 - note <https://note.com/minato_kame/n/neb271c81e0e2>`_
* `Terraform v1.9 では null_resource を安全に terraform_data に置き換えることができる -Zenn <https://zenn.dev/terraform_jp/articles/tf-null-resource-to-terraform-data>`_
* `【OCI】ブロックボリュームのアタッチ手順とアタッチタイプについて！ - techblog APC <https://techblog.ap-com.co.jp/entry/2025/06/12/155721>`_
* `Oracle Cloud Infrastructureブロック・ボリューム・バックアップDeep Dive - Qiita <https://qiita.com/yamada-hakase/items/c379acacba1db1bd64d9>`_
* `AWS/Azure 経験者がはじめる OCI 入門 ～ Compute編 ～ - Qiita <https://qiita.com/Skogkatter112/items/540da610c7938cb74b55>`_
