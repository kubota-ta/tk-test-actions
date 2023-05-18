#============================================================================ 
# Github Actions 用ロール 
#============================================================================ 
# ----------------------------------------------------------------------------- 
# GitHub Actions プロバイダー設定 
# ----------------------------------------------------------------------------- 
resource "aws_iam_openid_connect_provider" "terra_cicd_demo" { 
  url             = "https://token.actions.githubusercontent.com" 
  client_id_list  = ["sts.amazonaws.com"] 
  # このコードは固定値 
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"] 
} 
 
# ----------------------------------------------------------------------------- 
# GitHub Actions 用ロール作成 
# ----------------------------------------------------------------------------- 
resource "aws_iam_role" "terra_cicd_demo_oidc_role" { 
  name = "TerraCICDDemoOIDCRole" 
  path = "/" 
  assume_role_policy = jsonencode({ 
    Version = "2012-10-17" 
    Statement = [{ 
      Effect = "Allow" 
      Action = "sts:AssumeRoleWithWebIdentity" 
      Principal = { 
        Federated = aws_iam_openid_connect_provider.terra_cicd_demo.arn 
      } 
      Condition = { 
        StringLike = { 
          "token.actions.githubusercontent.com:sub" = [ 
            # リポジトリ制限 

            # リポジトリに複数のブランチを作成している場合は特定のブランチを絞ることができる。リスト化もできる。 
            "repo:kubota-ta/tk-test-actions:*",
          ] 
        } 
      } 
    }] 
  }) 
} 
 
# ----------------------------------------------------------------------------- 
# ポリシーのアタッチ（AdministratorAccess_attachment） 
# ----------------------------------------------------------------------------- 
resource "aws_iam_role_policy_attachment" "AdministratorAccess_attachment" { 
  role       = aws_iam_role.terra_cicd_demo_oidc_role.name 
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess" 
}   
