# 2-Seccion-Principal
1. [Terraform State](#schema1)
2. [Comandos en Terraform](#schema2)
3. [Lifecycles](#schema3)
4. [ Practica AWS - Acceder a la instancia publica](#schema4)
5. [Provisioners](#schema5)
6. [Terraform Taint](#schema6)
7. [Logs en Terraform](#schema7)
8. [Importar recursos](#schema8)
9. [Count Vs For_each](#schema9)
10. [Funciones de Terraform](#schema10)
11. [Estructura condicional](#schema11)
12. [Locals](#schema12)
13. [Dynamic blocks](#schema13)
14. [Modulos](#schema14)
15. [Terraform Cloud](#schema15)
16. [ Herramientas complementarias](#schema16)

17. [Glosario](#schemaref)

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

<hr>

<a name="schema4"></a>

## 4. Practica AWS - Acceder a la instancia pública

Nos faltan recursos para poder conectarnos desde internet a nuestra instancia en nuestra subnet pública.

### Recursos que nos faltan:
- **Internet gateway:** punto de entrada y salida, desde internet hacia los recursos y de los recursos hacia internet.

    - El recurso `aws_internet_gateway` en Terraform se refiere específicamente a un Internet Gateway (IGW) en AWS, que es un componente de red específico en Amazon VPC. Sin embargo, AWS ofrece varios tipos de "gateways" y es importante diferenciarlos.
- **Tabla de enrutamiento:**
En AWS, una tabla de rutas `route table` es un componente fundamental dentro de la Virtual Private Cloud (VPC) que define cómo se enruta el tráfico de red dentro de la VPC. Una tabla de rutas contiene un conjunto de reglas (rutas) que determinan hacia dónde se debe enviar el tráfico de red basado en la dirección IP de destino.


- **aws_route_table_association.example_association:**

    - Asocia la tabla de rutas creada con la subnet. Esto asegura que el tráfico saliente de la subnet siga las reglas definidas en la tabla de rutas.

- **Security group**

El recurso de Security Group en AWS es un componente crucial de la seguridad en la nube, utilizado para controlar el tráfico entrante y saliente de las instancias EC2 (y otros recursos compatibles) en una VPC. Los Security Groups actúan como firewalls virtuales que definen qué tráfico está permitido hacia o desde los recursos asociados.



### ¿Qué es un Internet Gateway (IGW)?
- Un Internet Gateway es un componente que permite que los recursos en una VPC puedan comunicarse con Internet. Es un punto de entrada y salida entre la VPC y el Internet. Los Internet Gateways son esenciales para que las instancias EC2 y otros recursos dentro de una VPC puedan recibir y enviar tráfico a través de Internet.

### Características principales del Internet Gateway:
- Entrada y Salida de Tráfico:

    - Permite a las instancias en subnets públicas de una VPC enviar y recibir tráfico desde y hacia Internet.
- Redundancia y Alta Disponibilidad:

   - El Internet Gateway es altamente disponible y tolerante a fallos, escalando automáticamente para gestionar el tráfico.
- Requisitos para el Tráfico Saliente:

    - Las instancias deben tener una dirección IP pública o una Elastic IP y deben estar en una subnet asociada con una tabla de rutas que apunte al IGW para que el tráfico saliente funcione.


### ¿Qué es una Tabla de Rutas en AWS?
- Función: La tabla de rutas especifica cómo el tráfico de red desde las subnets (y, por extensión, desde las instancias dentro de esas subnets) debe ser dirigido. Cada subnet dentro de una VPC está asociada a una tabla de rutas, que puede ser la tabla de rutas predeterminada de la VPC o una personalizada.

- Componentes: Cada entrada en una tabla de rutas incluye:

    - Destino (Destination): Un rango de direcciones IP (CIDR) que define el destino del tráfico.
    - Target (Destino): El recurso al que debe enviarse el tráfico destinado, como un Internet Gateway, una NAT Gateway, una instancia EC2, o un Transit Gateway.



### ¿Qué es un Security Group en AWS?
- Función: Los Security Groups controlan el tráfico de red a nivel de instancia, es decir, definen las reglas que permiten o bloquean el tráfico entrante y saliente en función de varios criterios, como el puerto, el protocolo, y las direcciones IP de origen o destino.

- Estado: Los Security Groups son stateful, lo que significa que si permites el tráfico entrante, la respuesta correspondiente es permitida automáticamente (no es necesario definir reglas de salida separadas para la respuesta).

- Reglas de Seguridad:

    - Reglas de Ingreso (Inbound Rules): Controlan el tráfico que se permite entrar a las instancias.
    - Reglas de Egreso (Outbound Rules): Controlan el tráfico que se permite salir de las instancias.

- [DOC Internet Gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway)
- [DOC Route Table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) 
- [DOC Route Table Association ](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association)
- [DOC Security Group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)

<hr>

<a name="schema5"></a>

## 5. Provisioners

Los `provisioners` en Terraform son bloques que se utilizan para ejecutar scripts o comandos locales o remotos en una instancia de recurso, generalmente después de que el recurso ha sido creado o actualizado. Son útiles para realizar configuraciones finales, ejecutar scripts de arranque, instalar software, o realizar cualquier otra tarea que necesite ejecutarse en el recurso una vez que esté disponible.


### Tipos de Provisioners
Terraform soporta varios tipos de provisioners, incluyendo:

- local-exec Provisioner:

    - Ejecuta comandos o scripts en la máquina local donde se está ejecutando Terraform.
    - Útil para tareas como invocar comandos del sistema o scripts locales después de crear un recurso.
        ```hcl
        resource "aws_instance" "example" {
        ami           = "ami-123456"
        instance_type = "t2.micro"

        provisioner "local-exec" {
            command = "echo ${aws_instance.example.public_ip} >> ip_addresses.txt"
        }
        }
        ```    
- remote-exec Provisioner:

- Ejecuta comandos o scripts en la máquina remota (como una instancia EC2) después de que el recurso ha sido creado.
- Utiliza SSH o WinRM para conectarse a la instancia.
        ```hcl
        resource "aws_instance" "example" {
        ami           = "ami-123456"
        instance_type = "t2.micro"

        connection {
            type        = "ssh"
            user        = "ubuntu"
            private_key = file("~/.ssh/id_rsa")
            host        = self.public_ip
        }

        provisioner "remote-exec" {
            inline = [
            "sudo apt-get update",
            "sudo apt-get install -y nginx",
            ]
        }
        }
        ```
- file Provisioner:

    - Sirve para transferir archivos o directorios desde la máquina local a la máquina remota.
    - Utiliza la misma configuración de conexión que el remote-exec.
        ```hcl
        resource "aws_instance" "example" {
        ami           = "ami-123456"
        instance_type = "t2.micro"

        connection {
            type        = "ssh"
            user        = "ubuntu"
            private_key = file("~/.ssh/id_rsa")
            host        = self.public_ip
        }

        provisioner "file" {
            source      = "index.html"
            destination = "/var/www/html/index.html"
        }
        }
        ```

- Orden de Ejecución
    - Los provisioners se ejecutan después de que el recurso ha sido creado. Si el recurso no se puede crear (por ejemplo, si la instancia EC2 no se inicia correctamente), los provisioners no se ejecutarán.

- Fallos y Reintentos
    - Por defecto, si un provisioner falla, Terraform marcará el recurso como fallido y no continuará con la ejecución. Puedes cambiar este comportamiento usando el atributo on_failure.

    ```hcl
    provisioner "remote-exec" {
    inline = [
        "some-failing-command",
    ]

    on_failure = "continue"  # Las opciones son "continue" o "fail"
    }
    ```
### Casos de Uso Comunes
- Configuración de Software: Instalar paquetes, configurar servicios, o desplegar aplicaciones una vez que la instancia está activa.
- Transferencia de Archivos: Copiar archivos de configuración, scripts, o cualquier otro recurso necesario a la instancia.
- Notificaciones: Ejecutar comandos que notifiquen a otros sistemas que el recurso está disponible o que la configuración ha terminado.
- Ejecutar Scripts de Shell: Ejecutar scripts de shell complejos en la instancia para realizar tareas específicas.
### Consideraciones y Buenas Prácticas
- Provisioners como último recurso: Terraform recomienda usar provisioners solo cuando no es posible lograr el mismo resultado a través de recursos declarativos nativos de Terraform o cuando necesitas realizar una tarea específica de configuración.
- Idempotencia: Asegúrate de que los scripts que ejecutas con provisioners sean idempotentes, es decir, que puedan ejecutarse varias veces sin causar efectos adversos.
- Alternativas a los provisioners: Siempre que sea posible, es preferible usar recursos específicos de Terraform o herramientas de configuración de administración como Ansible, Chef, o Puppet, que están mejor equipadas para gestionar la configuración de instancias.
### Resumen
Los `provisioners` en Terraform son herramientas poderosas para ejecutar comandos o scripts en máquinas locales o remotas durante la creación de recursos. Aunque son útiles para configuraciones finales y tareas post-creación, deben usarse con precaución, ya que introducen imperativos en un flujo declarativo. Terraform recomienda que los `provisioners` sean utilizados solo cuando sea absolutamente necesario y cuando no existan alternativas declarativas más adecuadas.


<hr>

<a name="schema6"></a>

## 6. Terraform Taint


El comando `terraform taint` en Terraform se utiliza para marcar un recurso como "dañado" `tainted`. Esto indica que el recurso debe ser recreado en la próxima ejecución del plan de Terraform. Es una forma de forzar la recreación de un recurso sin necesidad de hacer cambios en la configuración.

### ¿Qué es terraform taint?
- Objetivo: terraform taint marca un recurso como "dañado" para que Terraform lo recree. 
    - Esto es útil en situaciones en las que el recurso está en un estado problemático o no deseado y se necesita recrear desde cero.

- Funcionamiento: Cuando un recurso es marcado como dañado, Terraform lo incluirá en la lista de recursos que deben ser destruidos y recreados en la próxima ejecución del plan. El recurso será destruido y luego creado de nuevo con la configuración actual.

### Uso Básico
- Aquí está un ejemplo básico de cómo se usa el comando terraform taint:

```sh
terraform taint aws_instance.example
```
- Este comando marca el recurso aws_instance.example como dañado. En la siguiente ejecución de terraform apply, Terraform destruirá esta instancia y la creará nuevamente.


<hr>

<a name="schema7"></a>

## 7. Logs en Terraform

En Terraform, los logs son una herramienta crucial para la depuración y el monitoreo del proceso de provisión y gestión de la infraestructura. Proporcionan información detallada sobre las operaciones realizadas por Terraform, como la creación, modificación y destrucción de recursos.

### Tipos de Logs en Terraform
- Logs de Ejecución:

    - Estos logs muestran la salida estándar de los comandos de Terraform (terraform apply, terraform plan, etc.). Incluyen información sobre las acciones que Terraform está llevando a cabo, así como el estado de los recursos.
- Logs de Depuración:

    - Terraform permite habilitar un modo de depuración detallado que proporciona una visión más profunda sobre lo que está ocurriendo bajo el capó. Estos logs pueden ser muy útiles para solucionar problemas complejos y entender cómo Terraform interactúa con los proveedores y recursos.
### Configuración de Logs en Terraform
- Habilitar Logs de Depuración
    - Para habilitar el modo de depuración en Terraform, se utiliza la variable de entorno TF_LOG. Esta variable controla el nivel de detalle de los logs generados por Terraform.

- Niveles de Log Disponibles:
    - TRACE: Proporciona el nivel más detallado de información de depuración.
    - DEBUG: Muestra detalles extensos sobre la operación de Terraform, pero menos detallado que TRACE.
    - INFO: Proporciona información general sobre las operaciones de Terraform, ideal para la mayoría de los casos de uso.
    - WARN: Muestra advertencias que pueden indicar problemas potenciales.
    - ERROR: Muestra solo los errores críticos que impiden que Terraform ejecute las operaciones correctamente.
### Ejemplo de configuración:

```sh
export TF_LOG=DEBUG
```
- Una vez que hayas establecido TF_LOG, Terraform comenzará a emitir logs en la salida estándar. Puedes redirigir estos logs a un archivo para análisis posterior:

```sh
export TF_LOG=DEBUG
terraform apply > terraform_debug.log 2>&1
```
Esto redirige tanto la salida estándar como los errores al archivo terraform_debug.log.

### Configuración de la Variable TF_LOG_PATH
- Si prefieres guardar los logs en un archivo específico, puedes usar la variable de entorno TF_LOG_PATH para definir la ruta del archivo de log.

Ejemplo:

```sh
export TF_LOG_PATH="/path/to/terraform.log"
```
o guardar el archivo en un .txt
```sh
export TF_LOG_PATH=logs.txt
```
- Con esta configuración, Terraform escribirá los logs en el archivo especificado, lo que facilita la revisión y análisis posterior.

### Ejemplos de Uso
- Depuración de Problemas:
    - Si encuentras un error al ejecutar terraform apply, puedes habilitar los logs de depuración para obtener más detalles sobre lo que está fallando.
### Monitorización y Auditoría:
- Para una auditoría completa de las operaciones de Terraform o para monitorear cambios y actividades, puedes revisar los logs generados.
### Análisis de Desempeño:
- Los logs detallados pueden ayudar a identificar cuellos de botella o problemas de rendimiento en la provisión de recursos.
### Resumen
En Terraform, los logs son esenciales para depurar y entender el comportamiento de las operaciones de infraestructura. Puedes habilitar diferentes niveles de logging usando la variable de entorno TF_LOG y redirigir los logs a archivos específicos con TF_LOG_PATH. Los logs detallados pueden ayudar a resolver problemas complejos, monitorear operaciones y auditar actividades, proporcionando una visión más profunda del funcionamiento interno de Terraform.

### Eliminar las variables
- Obtener las variables `TF_LOG`
```
env | grep TF_LOG
```
- Eliminar las variables
```
unset TF_LOG
``` 

<hr>

<a name="schema8"></a>

## 8. Importar recursos


Que sucede cuando tenemos recrusos que alguien a desplagado sin terraform sino directamente en la consola de AWS. 
Podemos usar la sección de `import` de terraform para traernos recursos.
![import](./img/import.jpg).

Cada recurso en AWS se puede importar en terraform, mediante un elemento distintivo del recurso, el `id`, o en el caso de las subnet el `subent_id`.

- Para este ejemplo, desplegamos la practica 6. Como tenemos instancias creadas vamos a eliminarlas para poder crearlas desde la consola y hacer los imports.
    - Desde la consola de amazon eliminamos la instacia EC2. Y desde nuestra terminal:
        - `terraform state list`, para ver los recursos desplegados.
        - `terraform state rm aws_instace.public_instance`: eliminamos esta instancia.
- Creamos la instacia desde las consola de amazon:
    - Creamos la instancia.
    - Con nuestro vpc_virginia, nuestro security group y nuestra subnet publica.
    ![EC2](./img/ec2.jpg)

- Hacemos el import. En el archivo `ec2.tf`creamos el siguiente código.
```
resource "aws_instance" "mywebserver" {
  
}
```
El código de una instacia vacía. 
- Ahora hacemos el terraform import.
```
terraform import aws_instance.mywebserver i-0113b20a1790ae521
```
Esto hace que el recurso anterior tenga código pero si nos hemos lo tenemos en state
![Import](./img/ec2_import.jpg)

Para ver el código podemos hacer:
`terraform state show aws_instance.mywebserver`
y copiamos el resultado. Quedando así:

```resource "aws_instance" "mywebserver" {
    ami                                  = "ami-0ae8f15ae66fe8cda"
    instance_type                        = "t2.micro"
    key_name                             = data.aws_key_pair.key.key_name
    subnet_id                            = aws_subnet.public_subnet.id
    tags                                 = {
        "Name" = "MyServer"
    }
    vpc_security_group_ids               = [
        aws_security_group.sg_public_instace.id
    ]

}
```

### Destruir los recursos

`terraform destroy -auto-approve=true`


<hr>

<a name="schema9"></a>

## 9. Count Vs For_each
En Terraform, tanto count como for_each son mecanismos que permiten la creación de múltiples instancias de un recurso, pero se utilizan en situaciones diferentes y tienen características distintas.

### `count` en Terraform

El atributo count es una forma sencilla de crear múltiples instancias de un recurso basado en un número entero.

#### Características:
- Uso Básico: Es ideal para casos en los que solo necesitas un número fijo de recursos, como "quiero 3 instancias de EC2".
- Indexación: Los recursos creados con count se indexan a partir de 0. Esto significa que puedes acceder a cada recurso utilizando su índice, como aws_instance.example[0].
- Limitaciones: Solo permite crear instancias basadas en un número entero y no es adecuado para crear recursos basados en valores específicos.

```hcl
resource "aws_instance" "example" {
  count         = 3
  ami           = "ami-123456"
  instance_type = "t2.micro"

  tags = {
    Name = "example-instance-${count.index}"
  }
}
```
En este caso, Terraform creará 3 instancias EC2. Puedes acceder a cada instancia usando su índice, por ejemplo, aws_instance.example[0].

### `for_each` en Terraform

El atributo `for_each` permite crear múltiples instancias de un recurso basándose en un mapa o un conjunto de valores únicos, ofreciendo mayor flexibilidad que `count`.

#### Características:
- Uso Basado en Conjuntos y Mapas: Es ideal cuando tienes un conjunto de elementos únicos o un mapa y deseas crear recursos basados en cada elemento.
- Identificación por Claves: Los recursos creados con for_each se identifican por la clave del mapa o el valor del conjunto, lo que facilita la identificación y manipulación de recursos específicos.
- Flexibilidad: Es más flexible que count, ya que puedes asociar directamente un recurso con un elemento específico del conjunto o mapa.
```hcl
resource "aws_instance" "example" {
  for_each = {
    instance1 = "ami-123456"
    instance2 = "ami-654321"
  }
  
  ami           = each.value
  instance_type = "t2.micro"

  tags = {
    Name = each.key
  }
}
```
En este ejemplo, Terraform creará dos instancias EC2, una con el nombre `instance1` y otra con el nombre `instance2`. La instancia `instance1` usará el AMI `"ami-123456"` y la instancia `instance2` usará `"ami-654321"`.

### Comparación count vs for_each
- Escenarios de Uso:

    - `count`: Útil cuando necesitas un número fijo de recursos o cuando las diferencias entre los recursos son mínimas.
    - `for_each`: Ideal cuando trabajas con un conjunto o un mapa de elementos únicos y necesitas una mayor granularidad o diferenciación entre los recursos.
- Acceso a Recursos:

    - `count`: Los recursos se identifican por un índice numérico (aws_instance.example[0]).
    - `for_each`: Los recursos se identifican por claves (aws_instance.example["instance1"]).
- Flexibilidad:
    - `count`: Menos flexible, solo funciona con números enteros.
    - `for_each`: Más flexible, puede usar mapas y conjuntos para definir recursos.
### Resumen
- `count`: Es simple y efectivo para crear un número fijo de recursos que son prácticamente idénticos, con diferencias menores.
- `for_each`: Es más versátil y adecuado para crear múltiples recursos basados en valores específicos de un conjunto o mapa, permitiendo un mayor control y diferenciación entre los recursos.

[Código del ejemplo](./practica_7/)

- Primero ejemplo con lista de nombres, por lo tanto tiene índices.
![Lista de nombres](./img/count_list.jpg)
- Segundo ejemplo, eliminamos de la lista la instancia "apache",   `default = [ "mysql","jumpserver" ]`.
![Delete apache](./img/list_apache_del.jpg)
En este caso no ha eliminado la instancia apache, sino que ha cambiado el orden y la que ha elimiando es la última porque solo tenemos dos índices.
No importa el elemento que borres, sino su posición.

- Tercer ejemplo, con `foreach`, en este caso no usamos índices númericos sino índices con los nombres del set.
![Foreach](./img/for_each_set.jpg)
![Foreach](./img/foreach_state.jpg)
- Eliminamos de la lista la instancia "apache",   `default = [ "mysql","jumpserver" ]`.
![Foreach](./img/foreach_destroy.jpg)
En este caso si elimina la instacia "apache".
- También podemos usar `toset`para seguir usando `list(string)`


<hr>

<a name="schema10"></a>

## 10. Funciones de Terraform

Para poder ver el funcionamiento de las funciones en Terraform, vamos a usar la consola de terraform, `terraform console` y para salir `exit`

Las funciones en Terraform son herramientas poderosas que te permiten manipular y transformar datos dentro de tus configuraciones de infraestructura como código. Terraform incluye una amplia variedad de funciones que puedes utilizar en expresiones para gestionar valores, transformar datos, y controlar la lógica en tus configuraciones.

### Tipos de Funciones en Terraform
Terraform organiza sus funciones en varias categorías, dependiendo de su propósito:

1. Funciones de Cadena (String Functions)

    -  `lower` y `upper`: Convierte una cadena a minúsculas o mayúsculas.
        ```hcl
        lower("HELLO")  # "hello"
        ```
    - `concat`: Combina varias cadenas en una sola.
        ```hcl
        concat("foo", "bar")  # "foobar"
        ```
    - `format`: Da formato a una cadena utilizando especificadores de formato.
        ```hcl
        format("Hello, %s!", "World")  # "Hello, World!"
        ```
    - `replace`: Reemplaza todas las ocurrencias de una subcadena en una cadena.
        ```hcl
        replace("Hello World", "World", "Terraform")  # "Hello Terraform"
        ```
    - `title` en Terraform convierte la primera letra de cada palabra en una cadena de texto a mayúscula, mientras que el resto de las letras de la palabra permanecen en minúscula.
        ```hcl
        output "formatted_title" {
        value = title("terraform infrastructure as code")
        }
        # Terraform Infrastructure As Code
        ```
    - `substr` en Terraform extrae una subcadena de una cadena dada, comenzando desde una posición específica y con una longitud definida.

        Sintaxis:
        ```hcl
        substr(string, offset, length)
        ```
        - string: La cadena original de la que se va a extraer la subcadena.
        - offset: La posición inicial desde donde comenzar la extracción (basada en índice cero).
        - length: La longitud de la subcadena a extraer.
        ```hcl
        output "substring_example" {
        value = substr("terraform", 0, 4) # terr
        ```
    - `contains` en Terraform se utiliza para verificar si un valor específico existe dentro de una lista o un conjunto de elementos.
        ```hcl
        contains(list, value)
        ```
        - list: La lista o conjunto en el que se va a buscar el valor.
        - value: El valor que deseas comprobar si está presente en la lista.


2. Funciones de Colecciones (Collection Functions)

    - `length`: Devuelve el número de elementos en una lista, conjunto, o mapa.
        ```hcl
        length(["a", "b", "c"])  # 3
        ```
    - `element`: Devuelve el elemento de una lista en un índice específico.
        ```hcl
        element(["a", "b", "c"], 1)  # "b"
        ```
    - `join`: Combina los elementos de una lista en una cadena, usando un separador.
        ```hcl
        join(", ", ["a", "b", "c"])  # "a, b, c"
        ```
    - `lookup`: Devuelve el valor asociado a una clave específica en un mapa, con un valor por defecto si la clave no existe.
        ```hcl
        lookup({a = "apple", b = "banana"}, "a", "no fruit")  # "apple"
        ```
3. Funciones de Control de Lógica (Logical Functions)

    - `coalesce`: Devuelve el primer argumento no nulo.
        ```hcl
        coalesce(null, "", "default")  # ""
        ```
    - `condition`: Implementa una lógica condicional. (En lugar de esta función, Terraform usa operadores ternarios).
        ```hcl
        condition ? true_value : false_value
        ```
    - `can`: Evalúa si una expresión es válida y no produce un error.
        ```hcl
        can(regex("a", "b"))  # false
        ```
4. Funciones Matemáticas (Numeric Functions)

    - `min` y `max`: Devuelve el mínimo o máximo de una lista de números.
        ```hcl
        min(1, 2, 3)  # 1
        max(1, 2, 3)  # 3
        ```
    - `abs`: Devuelve el valor absoluto de un número.
        ```hcl
        abs(-5)  # 5
        ```
    - `ceil` y `floor`: Devuelven el menor número entero mayor o igual, o menor o igual, respectivamente.
        ```hcl
        floor(5.9)  # 5
        ```
5. Funciones de Fecha y Hora (Date and Time Functions)

    - `timestamp`: Devuelve la fecha y hora actuales en formato UTC.
        ```hcl
        timestamp()  # "2024-08-21T12:34:56Z"
        ```
    - `timeadd`: Suma un período de tiempo a un timestamp dado.
        ```hcl
        timeadd(timestamp(), "2h")  # Suma 2 horas al timestamp actual
        ```
6. Funciones de Depuración y Validación

    - `file`: Lee el contenido de un archivo.
        ```hcl
        file("path/to/file.txt")
        ```
    - `log`: Imprime un mensaje de depuración en el registro de Terraform.
        ```hcl
        log("Debug message")
        ```
    - `try`: Evalúa expresiones y devuelve el primer resultado válido, ignorando los errores.
        ```hcl
        try(lookup(var.map, "key", "default"), "fallback")  # "default" si "key" no existe
        ````
7. funciones para trabajar con mapas `maps`

- `lookup`: se utiliza para obtener el valor asociado a una clave específica en un mapa. Puedes especificar un valor predeterminado que se devuelve si la clave no existe en el mapa.

    ```hcl
    lookup(map, key, default)
    ```
    - map: El mapa en el que estás buscando.
    - key: La clave cuyo valor deseas obtener.
    - default: (Opcional) El valor que se devolverá si la clave no existe en el mapa.
        ```hcl
        variable "instance_types" {
        type = map(string)
        default = {
            "small"  = "t2.micro"
            "medium" = "t2.small"
            "large"  = "t2.medium"
        }
        }

        output "selected_instance" {
        value = lookup(var.instance_types, "medium", "t2.micro")
        }
        # t2.small

- `keys`: devuelve una lista de todas las claves de un mapa, en el orden en que fueron definidas.
    ```hcl
    keys(map)
    ```
    - map: El mapa del que deseas obtener las claves.

        ```hcl
        variable "instance_types" {
        type = map(string)
        default = {
            "small"  = "t2.micro"
            "medium" = "t2.small"
            "large"  = "t2.medium"
        }
        }

        output "map_keys" {
        value = keys(var.instance_types)
        }

        # ["small", "medium", "large"]
        ```

- `values`: devuelve una lista con todos los valores de un mapa.
    ```hcl
    values(map)
    ```
    - map: El mapa del que deseas obtener los valores.

    ```hcl
    output "map_values" {
    value = values(var.instance_types)
    }

    # ["t2.micro", "t2.small", "t2.medium"]
    ```

- `merge`: combina dos o más mapas en uno solo. Si hay claves duplicadas, el último valor sobrescribe a los anteriores.

    ```hcl
    merge(map1, map2, ...)
    ```
    - map1, map2, ...: Los mapas que deseas combinar.
    
    ```hcl
    variable "map1" {
    type = map(string)
    default = {
        "a" = "apple"
        "b" = "banana"
    }
    }

    variable "map2" {
    type = map(string)
    default = {
        "b" = "blueberry"
        "c" = "cherry"
    }
    }

    output "merged_map" {
    value = merge(var.map1, var.map2)
    }

    # resultado
    ardu```ino
    {
    "a" = "apple"
    "b" = "blueberry"
    "c" = "cherry"
    }
    ```
- `zipmap`: crea un mapa a partir de dos listas: una de claves y otra de valores. Cada clave se empareja con el valor correspondiente por su posición en la lista.

    ```hcl
    zipmap(keys, values)
    ```
    - keys: La lista de claves.
    - values: La lista de valores.

    ```hcl
    variable "keys" {
    default = ["small", "medium", "large"]
    }

    variable "values" {
    default = ["t2.micro", "t2.small", "t2.medium"]
    }

    output "zipped_map" {
    value = zipmap(var.keys, var.values)
    }
    # Resultado:

    ardu```ino
    {
    "small"  = "t2.micro"
    "medium" = "t2.small"
    "large"  = "t2.medium"
    }
    ```


<hr>

<a name="schema11"></a>

## 11. Estructura condicional

En Terraform, las estructuras condicionales te permiten tomar decisiones dentro de tu configuración en función de ciertas condiciones. La estructura condicional más común en Terraform es el operador ternario, que se usa para seleccionar un valor u otro según una condición booleana.

### Operador Ternario
El operador ternario en Terraform tiene la siguiente sintaxis:

```hcl
condition ? true_value : false_value
```
- condition: Una expresión booleana que se evalúa como true o false.
- true_value: El valor que se devuelve si la condición es true.
- false_value: El valor que se devuelve si la condición es false.

[Ejemplo](./practica_7/)


<hr>

<a name="schema12"></a>

## 12. Locals

Los `locals` en Terraform son bloques que permiten definir variables locales dentro de una configuración. Estos valores son inmutables y están diseñados para ser reutilizados en múltiples partes del código. Los locals ayudan a evitar la repetición de código, mejoran la legibilidad y facilitan la gestión de configuraciones complejas.

### Definición de locals
Un bloque locals se define de la siguiente manera:

```hcl
locals {
  local_name = expression
}
```
- local_name: Es el nombre que le das a la variable local.
- expression: Es cualquier expresión válida en Terraform, como valores constantes, resultados de funciones, cálculos, concatenaciones, etc.

- Primer ejemplo, con cadenas de string
[Ejemplo](./practica_7/)

- Segundo ejemplo, S3
[Doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)

![S3](./img/s3_sufix.jpg)
![Infra](./img/infra.jpg)



`terraform destroy`

<hr>

<a name="schema13"></a>

## 13. Dynamic Blocks


Los bloques dinámicos `dynamic blocks` en Terraform son una característica avanzada que te permite generar dinámicamente uno o más bloques de configuración dentro de un recurso o un módulo. Son especialmente útiles cuando necesitas repetir un mismo tipo de bloque dentro de un recurso varias veces, pero con diferentes parámetros.

### ¿Qué Problema Resuelven los Bloques Dinámicos?
Normalmente, si tienes múltiples instancias de un bloque anidado dentro de un recurso (como múltiples reglas de ingress o egress en un grupo de seguridad de AWS), tendrías que definir cada bloque de forma manual, lo que puede ser repetitivo y difícil de mantener si el número de bloques es grande o cambia dinámicamente.

Los bloques dinámicos permiten automatizar este proceso, evitando la repetición de código y permitiendo que la configuración sea más flexible y mantenible.

### Sintaxis de dynamic
El bloque dynamic se estructura de la siguiente manera:

```hcl
dynamic "block_name" {
  for_each = [iterable_expression]
  content {
    # Aquí dentro va el contenido del bloque que deseas repetir
    attribute = each.value
    # Otros atributos y configuraciones...
  }
}
```
- block_name: Es el nombre del tipo de bloque que deseas generar dinámicamente (por ejemplo, ingress, egress, tag, etc.).
- for_each: Es una expresión que devuelve una lista, un mapa o un conjunto que se itera para generar un bloque por cada elemento.
- content: Contiene la configuración que se repetirá, donde each.key y each.value pueden ser utilizados para acceder a las claves y valores de los elementos iterados.

<hr>

<a name="schema14"></a>

## 14. Modulos

![Modulos](./img/modulos.jpg)

En Terraform, un **módulo** es una unidad de organización y reutilización de código. Un módulo es simplemente una colección de archivos de configuración que definen una infraestructura. En esencia, todos los directorios de Terraform son módulos, ya que cada directorio contiene recursos y configuraciones que pueden ser reutilizados.

### ¿Por qué Usar Módulos?
Los módulos permiten organizar y reutilizar configuraciones, proporcionando:

1. **Reutilización de código**: Puedes definir un conjunto de recursos comunes y usarlos en diferentes partes de tu infraestructura.
2. **Mantenimiento sencillo**: Actualizar un módulo cambia automáticamente todas las instancias donde se utiliza.
3. **Abstracción**: Puedes encapsular configuraciones complejas dentro de un módulo y usarlo de manera más simple.
4. **Organización**: Mejora la estructura y legibilidad del código en grandes infraestructuras.
### Ejemplo Básico de Módulo
Un módulo en Terraform tiene una estructura similar a la de una configuración estándar de Terraform. Puede contener:

- Variables (variables.tf): Definen los valores de entrada.
- Recursos (main.tf): Contienen los recursos que crean la infraestructura.
- Outputs (outputs.tf): Definen los valores de salida que pueden ser usados por otros módulos o configuraciones.
### Estructura de un Módulo
Supongamos que tenemos un módulo llamado ec2_instance:

```css
module/
├── main.tf
├── variables.tf
└── outputs.tf
```

### Usar un Módulo en Terraform
Para usar un módulo, simplemente lo invocas desde otro archivo main.tf. La invocación de un módulo se realiza mediante el bloque module, donde defines el origen del módulo (puede estar en un repositorio, una URL o una ruta local) y proporcionas valores para sus variables de entrada.


### Módulos Hijos (Submódulos)
Los módulos hijos (también conocidos como submódulos) son módulos que se invocan desde otro módulo. En otras palabras, cuando un módulo invoca otro módulo, el módulo invocado se convierte en un módulo hijo.

#### Cómo Funcionan los Módulos Hijos
Si un módulo A invoca un módulo B, entonces B es un módulo hijo de A. Esta jerarquía permite construir configuraciones complejas y modulares, donde cada módulo se encarga de una parte de la infraestructura. Los módulos hijos se usan para dividir y organizar la lógica de manera más granular.

#### Ejemplo de Módulo con Módulo Hijo
Supongamos que tenemos un módulo padre que invoca un módulo hijo para crear una VPC y otro módulo hijo para crear una instancia EC2 dentro de esa VPC.

#### Estructura del Módulo Padre
```css
parent_module/
├── main.tf
├── variables.tf
└── outputs.tf
```
Contenido de main.tf del Módulo Padre
```hcl
module "vpc" {
  source = "./vpc_module"  # Módulo hijo que crea la VPC
  cidr   = var.vpc_cidr
}

module "ec2" {
  source        = "./ec2_module"  # Módulo hijo que crea la EC2
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = module.vpc.public_subnet_id
}
```
Módulo Hijo vpc_module
Este módulo crea una VPC y subredes:

```hcl
resource "aws_vpc" "example" {
  cidr_block = var.cidr
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-1a"
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}
```
Módulo Hijo ec2_module
Este módulo lanza una instancia EC2 en la VPC creada por el módulo anterior:

```hcl
resource "aws_instance" "example" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  tags = {
    Name = "example-instance"
  }
}
```
#### Beneficios de los Módulos Hijos
- Modularidad: Permite descomponer infraestructuras complejas en componentes más pequeños y manejables.
- Reutilización: Los módulos hijos pueden ser invocados por diferentes módulos padres, facilitando la reutilización de código.
- Organización: Mejora la organización del código, especialmente en infraestructuras grandes.
#### Prácticas Recomendadas para el Uso de Módulos
- Separar módulos por función: Divide los módulos según los componentes de la infraestructura (por ejemplo, un módulo para VPC, otro para instancias EC2, etc.).
- Versionamiento: Siempre que sea posible, usa módulos versionados (especialmente si provienen de fuentes externas como el Terraform Registry) para garantizar estabilidad.
- Documentación: Documenta tus módulos y submódulos para que otros miembros del equipo puedan usarlos fácilmente.
- Variables de entrada y salida: Define claramente las variables de entrada y los outputs que se necesitan para facilitar la integración con otros módulos.


[Doc](https://registry.terraform.io/browse/modules)

[Practica](./practica_8/)

Vamos a usar un módulo de la comunidad.

[Modulo](https://registry.terraform.io/modules/cloudposse/tfstate-backend/aws/latest)


<hr>

<a name="schema15"></a>

## 15. Terraform Cloud

![Terraform Cloud](./img/cloud.jpg)
![Terraform Cloud](./img/cloud2.jpg)
![Terraform Cloud](./img/cloud3.jpg)

Terraform Cloud es una solución SaaS para equipos que usan Terraform, proporcionando una plataforma colaborativa, centralizada y automatizada para gestionar la infraestructura como código. Ofrece almacenamiento remoto del estado, ejecución automática de planes, integración con sistemas de control de versiones y herramientas de notificación, y políticas de gobernanza para un mayor control y seguridad. Es especialmente útil para equipos grandes o distribuidos, proporcionando una mejor forma de gestionar la infraestructura de manera eficiente y segura.

<hr>

<a name="schema16"></a>

## 16. Herramientas complementarias

### 1. Infracost

- [Repositorio en github](https://github.com/infracost/infracost)
- [Pagina oficial](https://www.infracost.io/docs/#quick-start)
- Plugin de visual studio `Infracost` 
**Infracost** es una herramienta de código abierto que te permite estimar el costo de tu infraestructura en la nube antes de implementarla, integrándose directamente con tus archivos de configuración de Terraform. Te proporciona un desglose detallado de los costos basados en los recursos declarados, ayudando a prever los gastos y a optimizar el uso de la infraestructura en plataformas como AWS, Google Cloud, y Azure. Infracost se puede integrar con flujos de trabajo CI/CD para generar informes de costos automáticamente al hacer cambios en tu infraestructura.

Características principales:

- Estimaciones en tiempo real de costos de la nube.
- Comparación de costos entre diferentes configuraciones.
- Integración con Terraform y flujos de trabajo CI/CD.

### 2. Terraform Security
- [Repositorio en github](https://github.com/aquasecurity/tfsec)
- Plugin de visual studio `tfsec` 
**Tfsec** es una herramienta de seguridad estática para Terraform que analiza los archivos de configuración buscando vulnerabilidades y malas prácticas. Es compatible con múltiples proveedores de nube, como AWS, Azure, y Google Cloud, y detecta posibles problemas de seguridad antes de que los recursos se implementen, como permisos excesivos, configuraciones inseguras o recursos que podrían exponer información sensible.

Características principales:

- Análisis de seguridad estático de Terraform.
- Soporte para múltiples proveedores de nube.
- Informe de errores de seguridad con recomendaciones para resolverlos.-

### 3. Terraform Linter
- [Repositorio en github](https://github.com/terraform-linters/tflint)

Un **Terraform Linter** es una herramienta que revisa el estilo y la sintaxis de los archivos de configuración de Terraform para garantizar que sigan las mejores prácticas y convenciones. El linter ayuda a mejorar la calidad y coherencia del código, sugiriendo cambios para reducir errores y mejorar la legibilidad. Algunas herramientas populares incluyen tflint, que analiza problemas de configuración y errores potenciales.

Características principales:

- Verifica la sintaxis y el estilo de los archivos Terraform.
- Mejora la consistencia y la calidad del código.
- Identifica errores comunes antes de ejecutar Terraform.

### 4. Terrafomr Environment
- [Repositorio en github](https://github.com/tofuutils/tenv)
**Tenv** es un proyecto para gestionar múltiples entornos (dev, staging, prod) en Terraform de manera sencilla. A través de tenv, puedes usar la misma configuración de Terraform pero adaptarla a diferentes entornos sin duplicar archivos. Esto permite gestionar eficientemente los recursos según el entorno en el que se esté trabajando, aplicando diferentes configuraciones de manera modular.

Características principales:

- Facilita la gestión de múltiples entornos en Terraform.
- Evita la duplicación de archivos entre diferentes entornos.
- Uso modular y eficiente de configuraciones.

<hr>

<a name="schemaref"></a>

## 17. Glosario

[Glosario](https://developer.hashicorp.com/terraform/docs/glossary)