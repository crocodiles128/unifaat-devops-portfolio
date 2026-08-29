# Aula 03 - IAM TechNova

## Objetivo

Implementar uma estrutura IAM para a TechNova usando Terraform, com separacao de responsabilidades entre desenvolvedores, engenharia de plataforma e workloads EC2 que acessam S3.

## Recursos criados

- Grupo `SEURA-technova-developers`: acesso de leitura em buckets `technova-*`.
- Grupo `SEURA-technova-platform-eng`: gerenciamento operacional de EC2 e leitura/escrita em S3.
- Usuarios:
  - `SEURA-juliana-dev`: membro de developers.
  - `SEURA-rafael-platform`: membro de developers e platform-eng.
  - `SEURA-lucas-intern`: membro de developers, mantendo apenas leitura e deny destrutivo.
- Policies customizadas:
  - `SEURA-technova-s3-read`: permite `s3:GetObject` e `s3:ListBucket` em `technova-*`.
  - `SEURA-technova-ec2-s3-full`: permite `ec2:Describe*`, `ec2:StartInstances` e `ec2:StopInstances` somente em instancias com tag `Project = TechNova`, alem de leitura/escrita em S3.
  - `SEURA-technova-deny-destructive`: nega explicitamente `s3:Delete*` e `ec2:Terminate*`.
  - `SEURA-technova-ec2-s3-app-data`: permite que EC2 leia e escreva em `technova-app-data-*`.
- Role `SEURA-technova-ec2-role`, assumida por `ec2.amazonaws.com`.
- Instance profile `SEURA-technova-ec2-profile`.

## Decisoes de design

O design separa permissoes por grupos para facilitar manutencao e auditoria. O grupo developers recebe somente leitura em S3 e uma policy de deny explicito para reduzir risco de acoes destrutivas. O grupo platform-eng recebe permissoes adicionais, mas `StartInstances` e `StopInstances` exigem que a instancia EC2 tenha a tag `Project = TechNova`.

A role de servico usa trust policy para EC2 e uma policy especifica para buckets `technova-app-data-*`, evitando reutilizar permissoes humanas em workloads.

Todos os recursos tagueaveis recebem as tags obrigatorias por meio de `local.common_tags` e `default_tags` no provider AWS. As policies, users, role e instance profile tambem declaram `tags` diretamente para deixar a evidencia visivel no codigo. O recurso `aws_iam_group` nao aceita `tags` no provider AWS, por isso os grupos ficam sem esse argumento no Terraform.

## Como executar

```bash
terraform init
terraform fmt
terraform validate
terraform plan -out=tfplan
```

Para substituir os placeholders das tags:

```bash
terraform plan -var="aluno=Lucs José Campo da Rocha" -var="ra=6325123"
```

## Evidencia

O arquivo `terraform-plan-output.txt` contem a saida do `terraform plan` executado para esta atividade.
