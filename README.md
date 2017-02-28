crear contenedor compartiendo el driver de decklink
instalar dirver de decklink (https://www.blackmagicdesign.com/support/family/capture-and-playback) en el host y compartir los archivos como el ejemplo verificando la correcta ubicacion de los mismos
compartir carpeta test de mbc-mosto ya que de ahi accede a los archivos xml que ejecuta melted
compartir la carpeta de los videos
verificar que se tenga acceso tanto a los archivos xml y a los videos. ejecutando aplicacion rugen y tratando de acceder a todos los archivos

creo imagen
docker build -t melted

creo contenedor
docker create --name melted -i -t --device /dev/blackmagic/dv0 -p 5250:5250 -v /home/jose/melted.conf:/etc/melted/melted.conf -v /media/videos/proc:/media/videos/proc -v /etc/blackmagic/BlackmagicPreferences.xml:/etc/blackmagic/BlackmagicPreferences.xml -v /usr/lib/libDeckLinkAPI.so:/usr/lib/libDeckLinkAPI.so -v /home/jose/mbc-mosto/test:/test melted

ejecuto contenedor
docker start melted
