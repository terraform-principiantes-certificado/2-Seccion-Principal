# 2-Seccion-Principal
1. [Terraform State](#schema1)
2. [Comandos en Terraform](#schema2)
3. [Lifecycles](#schema3)


[REF](#schemaref)

<hr>

<a name="schema1"></a>

## 1. Terraform State

`terraform state` es un archivo que mantiene el registro de la infraestructura gestionada por Terraform. Este archivo es fundamental para el funcionamiento de Terraform, ya que almacena información sobre los recursos creados y su configuración actual, permitiendo a Terraform realizar un seguimiento y gestionar los recursos de manera eficiente y precisa.

### Funciones del Estado de Terraform
- Seguimiento de Recursos:
    - Mantiene un registro de todos los recursos que Terraform ha creado, actualizado o destruido.
    - Almacena los ID de los recursos y sus propiedades actuales.
- Planificación y Aplicación:
    - Permite a Terraform calcular con precisión los cambios necesarios comparando el estado actual con la configuración deseada.
    - Ayuda a evitar la recreación innecesaria de recursos.
- Depuración y Diagnóstico:
    - Proporciona una fuente de verdad sobre el estado de la infraestructura, facilitando la depuración y resolución de problemas.
- Modularidad:
    - Permite compartir datos entre diferentes módulos de Terraform.


### Ubicación del Estado
Por defecto, el estado se almacena localmente en un archivo llamado `terraform.tfstate` en el directorio donde se ejecuta Terraform. Sin embargo, para equipos grandes o entornos de producción, es recomendable usar un backend remoto para almacenar el estado, como Amazon S3, Terraform Cloud, Google Cloud Storage, entre otros.

### Comandos Relacionados con el Estado
Terraform proporciona varios comandos para interactuar con el estado:

- terraform init:
    - Inicializa el directorio de trabajo y configura el backend remoto si está especificado.
- terraform state list:
    - Lista todos los recursos en el estado.
        ```sh
        terraform state list
        ```
- terraform state show:
    - Muestra los detalles de un recurso específico en el estado.
        ```sh
        terraform state show aws_instance.example
        ````

- terraform state mv:
    - Mueve un recurso gestionado de un nombre a otro.
        ```sh
        terraform state mv aws_instance.old_name aws_instance.new_name
        ```
- terraform state rm:
    - Elimina un recurso del estado sin destruir el recurso real.
        ```sh
        terraform state rm aws_instance.example
        ```
- terraform state pull:
    - Descarga el estado actual de Terraform del backend remoto y lo muestra en la salida estándar.
        ```sh
        terraform state pull
        ````

- terraform state push:
    - Sube un archivo de estado al backend remoto.
        ```sh
        terraform state push
        ```


Es conveniente agregar el archivo de estado de Terraform `terraform.tfstate` y sus derivados `terraform.tfstate.backup` al archivo `.gitignor` para evitar que sean incluidos en el control de versiones. Existen varias razones para esto:

### Seguridad:
- El archivo de estado puede contener información sensible, como IDs de recursos, direcciones IP, credenciales, y otros detalles de configuración. Incluir estos archivos en un repositorio puede exponer datos confidenciales.

### Conflictos:
- El estado de Terraform es altamente dinámico y puede cambiar con cada terraform apply. Si múltiples usuarios trabajan en el mismo repositorio y el archivo de estado se versiona, pueden surgir conflictos difíciles de resolver.

### Integridad del Estado:
- El estado de Terraform debe ser una fuente de verdad única y consistente. Versionarlo en Git puede causar inconsistencias y problemas si se restaura una versión antigua del estado que ya no refleja la infraestructura actual.

### Uso de Backends Remotos:
- Cuando se utiliza un backend remoto (como Amazon S3, Terraform Cloud, Google Cloud Storage, etc.), el estado se almacena de manera centralizada y segura, eliminando la necesidad de versionarlo en Git.


Para tener un mayor control de estos archivos dentro de un equipo se podría añadir estos archivos a un `S3` con control de version y cifrado.

#### Ventajas de Usar S3 para el Estado de Terraform
- Consistencia y Coordinación:
    -   Asegura que todos los miembros del equipo trabajen con un estado de infraestructura único y consistente, evitando conflictos y discrepancias.

- Seguridad:
    -S3 permite configurar políticas de acceso y control de permisos, asegurando que solo los usuarios autorizados puedan acceder y modificar el archivo de estado.

- Versionado:
    - S3 puede mantener versiones de archivos, lo que permite recuperar estados anteriores si es necesario.

- Disponibilidad y Durabilidad:
    - S3 ofrece alta disponibilidad y durabilidad, asegurando que el estado esté siempre accesible y protegido contra pérdida de datos.

- Bloqueo de Estado:
    - Con el uso de DynamoDB para el bloqueo de estado, se evita que múltiples usuarios apliquen cambios simultáneamente, lo que previene la corrupción del estado.


#### Resumen
Al almacenar el estado de Terraform en un bucket de S3 con bloqueo de estado en DynamoDB, se mejora la colaboración en equipo, se garantiza la consistencia del estado y se refuerza la seguridad y la disponibilidad del estado de la infraestructura. Esta configuración es altamente recomendada para entornos de trabajo en equipo y producción.

- **Función de DynamoDB:** Gestionar el bloqueo de estado para evitar conflictos y mantener la consistencia del estado cuando múltiples usuarios trabajan en la misma infraestructura.
- **Configuración:** Crear una tabla de DynamoDB y configurar Terraform para usarla junto con el backend de S3.
- **Proceso:** Terraform intenta crear un bloqueo en DynamoDB antes de modificar el estado, asegurando que solo un proceso pueda hacer cambios a la vez.

<hr>

<a name="schema2"></a>


## 2. Comandos en Terraform

### Comandos para Gestión del Ciclo de Vida
- terraform apply:
    - Aplica los cambios necesarios para alcanzar el estado deseado de la configuración.
        ```sh
        terraform apply
        ```

- terraform plan:
    - Genera un plan de ejecución, mostrando los cambios que Terraform hará en la infraestructura.
        ```sh
        terraform plan
        ```
- terraform destroy:
    - Destruye la infraestructura gestionada por Terraform.
        ```sh
        terraform destroy
        ``` 

- terraform refresh:
    - Actualiza el estado de Terraform para que coincida con la infraestructura real.
        ```sh
        terraform refresh
        ```

- terraform init:
    - Inicializa un directorio de trabajo con archivos de configuración de Terraform.
        ```sh
        terraform init
        ```
- terraform validate:
    - Verifica que los archivos de configuración son válidos y que no hay errores de sintaxis.
        ```sh
        terraform validate
        ``` 


### Comandos para Gestión del Estado
- terraform state list:
    - Lista todos los recursos en el estado.
        ```sh
        terraform state list
        ```
- terraform state show:
    - Muestra los detalles de un recurso específico en el estado.
        ```sh
        terraform state show <resource_name>
        ```
- terraform state mv:
    - Mueve un recurso gestionado de un nombre a otro.
        ```sh
        terraform state mv <source> <destination>
        ```
- terraform state rm:
    - Elimina un recurso del estado sin destruir el recurso real.
        ```sh
        terraform state rm <resource_name>
        ```
- terraform state pull:
    - Descarga el estado actual de Terraform del backend remoto.
        ```sh
        terraform state pull
        ```
- terraform state push:
    - Sube un archivo de estado al backend remoto.
        ```sh
        terraform state push
        ```

### Comandos para Gestión de Recursos
- terraform import:
    - Importa recursos existentes en Terraform para que puedan ser gestionados.
        ```sh
        terraform import <resource_type>.<resource_name> <resource_id>
        ```
- terraform taint:
    - Marca un recurso para recrearlo en la próxima aplicación de cambios.
        ```sh
        terraform taint <resource_name>
        ``` 
- terraform untaint:
    - Desmarca un recurso que estaba marcado para recreación.
        ```sh
        terraform untaint <resource_name>
        ```
### Comandos para Optimización y Mantenimiento
- terraform fmt:
    - Formatea todos los archivos de configuración de Terraform en el directorio actual de acuerdo con el estilo de código estándar.
        ```sh
        terraform fmt
        ```
- terraform graph:
    - Genera un gráfico visual de las dependencias de recursos y lo imprime en formato DOT.
        ```sh
        terraform graph | dot -Tpng > graph.png
        ```
- terraform output:
    - Muestra las salidas definidas en la configuración de Terraform.
        ```sh
        terraform output
        ```
- terraform workspace:
    - Gestiona múltiples entornos (workspaces) dentro de una misma configuración.
        ```sh
        terraform workspace list
        terraform workspace new <workspace_name>
        terraform workspace select <workspace_name>
        terraform workspace delete <workspace_name>
        ```
- terraform version:
    - Muestra la versión de Terraform que está siendo utilizada.
        ```sh
        terraform version
        ```
- terraform providers:
    -  Lista los proveedores de infraestructura requeridos por la configuración.
        ```sh
        terraform providers
        ````

### Comandos para Debugging y Troubleshooting
- terraform console:
    - Abre una consola interactiva para evaluar expresiones de Terraform.
        ```sh
        terraform console
        ```
- terraform debug:
    - Ejecuta Terraform en modo debug, proporcionando información detallada para la resolución de problemas.
        ```sh
        TF_LOG=DEBUG terraform apply
        ```
### Otros Comandos Útiles
- terraform login:
    - Autentica con Terraform Cloud para acceder a las funciones avanzadas y almacenamiento de estado remoto.
        ```sh
        terraform login
        ```
- terraform logout:
    - Cierra la sesión de Terraform Cloud.
        ```sh
        terraform logout
        ```
<hr>

<a name="schema3"></a>

## 3. Lifecycles

En Terraform, los `lifecycles` (ciclos de vida) son un conjunto de reglas y configuraciones que se pueden aplicar a recursos individuales para controlar cómo Terraform maneja la creación, actualización y destrucción de esos recursos. Estos bloques permiten personalizar el comportamiento predeterminado de Terraform en varias situaciones, proporcionando un control más granular sobre la gestión de la infraestructura.


### Componentes del lifecycle en Terraform
El bloque lifecycle se coloca dentro de la configuración de un recurso y puede contener las siguientes propiedades clave:

- create_before_destroy:
    - Esta propiedad se utiliza para forzar a Terraform a crear un recurso nuevo antes de destruir el recurso existente. Es útil en casos donde el recurso antiguo necesita permanecer activo hasta que el nuevo esté completamente configurado.

    - Valor predeterminado: false

        ```hcl
        resource "aws_instance" "example" {
        ami           = "ami-123456"
        instance_type = "t2.micro"
        
        lifecycle {
            create_before_destroy = true
        }
        }
        ```
- prevent_destroy:
    - Esta propiedad evita que el recurso sea destruido accidentalmente. Si se intenta ejecutar un terraform destroy o una operación que implicaría la destrucción del recurso, Terraform lanzará un error y detendrá la ejecución.
    - Valor predeterminado: false

        ```hcl
        resource "aws_s3_bucket" "example" {
        bucket = "my-precious-bucket"
        
        lifecycle {
            prevent_destroy = true
        }
        }
        ```
- ignore_changes:
    - Esta propiedad le indica a Terraform que ignore cambios específicos en los atributos de un recurso cuando realice un terraform plan o terraform apply. Es útil cuando ciertos atributos son gestionados externamente o cuando no se desea que ciertos cambios provoquen una nueva aplicación.

        ```hcl
        resource "aws_instance" "example" {
        ami           = "ami-123456"
        instance_type = "t2.micro"
        
        lifecycle {
            ignore_changes = [
            tags["Name"],
            user_data,
            ]
        }
        }
        ```
    - En este ejemplo, si los tags o el user_data cambian fuera de Terraform, Terraform no intentará volver a aplicar esos cambios.

- replace_triggered_by:
    - Esta propiedad permite especificar que un recurso debe ser recreado si otro recurso o una variable cambia. Esta es una característica avanzada que te permite controlar la recreación de recursos en función de cambios en otros elementos de la configuración.



        ```hcl
        resource "aws_instance" "example" {
        ami           = "ami-123456"
        instance_type = "t2.micro"
        
        lifecycle {
            replace_triggered_by = [
            var.new_ami_id,
            aws_security_group.example.id,
            ]
        }
        }
        ```
    - En este caso, si el valor de `var.new_ami_id` o el ID del grupo de seguridad `aws_security_group.example` cambia, Terraform recreará la instancia aws_instance.example.

[Código de ejemplo](/practica_6/)
- `terraform apply`
- cambiamos esta linea en el archivo `ec2.tf`: 
```
  subnet_id =  aws_subnet.private_subnet.id 
```
- y hacemos un `terraform plan`, vemos que destruye la instancia y la crea de nuevo. Ahora vamos a ver como podemos hacer los con lifecycle.
- Vamos a usar `create_before_destroy` para que nos cree el recurso primero antes de destruirlo.
- Otro comando que podemos usar es el `prevent_destroy`.
![Error](./img/prevent_destroy_error.jpg)
Nos da un error porque este comando evita que sea destruido el recurso y como en nuestro caso tenemos que destruirlo para crearlo de nuevo por eso nos da este error.
- `ignore_changes`: ignore cambios específicos en los atributos de un recurso cuando realice un terraform plan o terraform apply.
```
lifecycle {
    ignore_changes = [ ami,subnet_id ]
  }
```
Al añadir estas líneas esta ignorando si hay algún cambio en el `ami` y en la `subnet_id`, como el ejercicio que estamos haciendo es de cambio en esta subnet_id, ignora totalmente ese cambio.
- `replace_triggered_by`:recurso debe ser recreado si otro recurso o una variable cambia.
```
  lifecycle {
    replace_triggered_by = [ 
      aws_subnet.private_subnet
     ]
  }
```
Si hacemos algún cambio en la subnet privada hara que se destruya y cree de nuevo la instacia EC2.
