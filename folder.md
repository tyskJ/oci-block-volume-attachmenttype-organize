# フォルダ構成

- フォルダ構成は以下の通り

```
.
└── envs
    ├── backend.tf      tfstateファイル管理定義ファイル
    ├── compute.tf      OCI compute定義ファイル
    ├── data.tf         外部データソース定義ファイル
    ├── locals.tf       ローカル変数定義ファイル
    ├── outputs.tf      リソース戻り値定義ファイル
    ├── providers.tf    プロバイダー定義ファイル
    ├── variables.tf    変数定義ファイル
    ├── vcn.tf          VCN定義ファイル
    └── versions.tf     Terraformバージョン定義ファイル
```