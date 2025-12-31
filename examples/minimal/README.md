# Minimal Security Group Example

Este es el ejemplo más simple posible del módulo Security Group. Crea un security group con una sola regla de ingreso (HTTP) permitiendo tráfico desde cualquier lugar.

## Características

- ✅ Security group con nomenclatura automática
- ✅ 1 regla de ingreso predefinida: HTTP (puerto 80)
- ✅ Permite tráfico desde 0.0.0.0/0
- ✅ Permite todo el tráfico de salida

## Uso

1. Copia el archivo de variables de ejemplo:
```bash
cp terraform.tfvars.example terraform.tfvars
```

2. Edita `terraform.tfvars` y actualiza el `vpc_id` con tu VPC:
```hcl
vpc_id = "vpc-12345678"  # Reemplaza con tu VPC ID
```

3. Inicializa y aplica:
```bash
terraform init
terraform plan
terraform apply
```

## Recursos Creados

- 1 Security Group
- 1 Regla de ingreso (HTTP desde 0.0.0.0/0)
- 1 Regla de egreso (Todo el tráfico)

## Salidas

- `security_group_id` - ID del security group
- `security_group_name` - Nombre del security group
- `security_group_arn` - ARN del security group

## Nombre del Security Group

Con los valores por defecto, el security group se llamará:
```
{region_prefix}-sg-dev-minimal
```

Ejemplo: `ause1-sg-dev-minimal` (en us-east-1)

## Limpieza

Para eliminar los recursos:
```bash
terraform destroy
```
