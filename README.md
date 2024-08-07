# 2-Seccion-Principal
1. [Terraform State](#schema1)



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
