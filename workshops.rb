require "sinatra"

get '/' do	
	@files = Dir.entries("workshops")

	@valor = 2 #Desde la plantilla tendra acceso a la variable @valor
	erb :home # IMPORTAR vistas PLANTILLAS .erb
	#HERENCIA PLANTILLAS , yield...
	#para heredar plantillas se le pasa un hash con layout: + :plantilla a heredar
	#SI TODAS LAS PAGINAS HEREDAN DE UNA PRINCIPAL PARA NO REPETIR SIEMPRE
end
#Esta ruta debe estar antes de la generica get '/:name' do si no usaria la generica erb :home, layout: :main
# SE NOMBRA A LA PLANTILLA COMO layout.erb Y TODAS LAS HEREDARAN AUTOMATICAMENTE
# PARA HEREDAR CUALQUIER OTRA erb :home, layout: :PLANTILLAAHEREDAR
get '/create' do
	erb :create
end

get '/:name/edit' do
	@name = params[:name]
	@description = workshop_content(@name)
	erb :edit
end


#RUTA GENERICA PARA NO TENER QUE CREAR UNA RUTA POR CADA VISTA
get '/:name' do
	#params es un array con los parametros de la URL
  @name = params[:name]
  @description = workshop_content(@name)
  erb :workshop #erb redirecciona a la view taller.erb
end 

def workshop_content(name)
	File.read("workshops/#{name}.txt")
rescue Errno::ENOENT
	return nil
end

#creara un archivo de nombre name y contenido description si no existe, si existe lo modifica
def save_workshop(name,description)
	File.open("workshops/#{name}.txt","w") do |file| #si no existe el archivo lo crea
		file.print(description)
	end
end

def delete_workshop(name)
	File.delete("workshops/#{name}.txt")
end

post '/create' do
  @name = params[:name]
  @description = params[:description]#si no hay return devuelve la ultima linea
  #{}"<h1>#{@name}</h1><p>#{@description}</p>"
  @message = "Taller #{@name} fué creado correctamente"
  save_workshop(@name, @description)
  erb :message  #new muestra mensajje de exito
end

delete '/:name' do
	delete_workshop(params[:name])
	@message = "Taller #{params[:name]} fué eliminado correctamente"
	erb :message
end

put '/:name' do
	save_workshop(params[:name],params[:description])
	redirect URI.escape("/#{params[:name]}")# URI.escape elimina los caracteres extraños en la url
end
#OBTNER LISTA DE ARCHIVOS DE UNA CARPETA
=begin
get '/' do	
	@files = Dir.entries("workshops")
	@files.each do |archivo|
		"<a>#{archivo}</a>"
	end
end

#RUTAS EN SINATRA
get '/basketball' do
  "<h1>Imagenes de la web</h1>"
end 

get '/imagenes' do
  "<h1>Imagenes de la web</h1>"
end

get '/contacto' do
  "<h1>Contactos de la web</h1>"
end   puedes ser post, get, put, delete
=end




