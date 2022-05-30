# Sacado de :
#  https://docs.openshift.com/container-platform/4.10/cicd/builds/running-entitled-builds.html

#obtenermos los certificados de una subcripcion de redhat, levantando una imagen ubi8 y ejecutando:
# subscription-manager register --auto-attach  --username=<usuario> --password=<passwd>
# una vez suscrito, los certificados estan en /etc/pki/entitlement

#creamos un secrets con los entitlement de mi subcripcion
oc create secret generic etc-pki-entitlement --from-file entitlement/7221715478687164096.pem --from-file entitlement/7221715478687164096-key.pem

# En el Dockerfile hay que ejecutar: RUN rm /etc/rhsm-host 
# para que funcione la subcripcion.


#Luego hay que añadir lo siguiente al buildconfig para que se inyecten los certificados de la subcripcion en la nueva imagen:
#
#strategy:
#  dockerStrategy:
#    from:
#      kind: ImageStreamTag
#      name: ubi:latest
#    volumes:
#    - name: etc-pki-entitlement
#      mounts:
#      - destinationPath: /etc/pki/entitlement
#      source:
#        type: Secret
#        secret:
#          secretName: etc-pki-entitlement


# Aqui cargamos el ejemplo de bc con lo anterior:

oc create -f buildconfig.yaml

