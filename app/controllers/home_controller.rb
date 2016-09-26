class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    #List.delete_all
    @status = 1
  end

  #list les lists
  def lists
    @playlists = List2.all
    @playlists.reverse_order!
    @playlistcode = params[:code]
    @message = params[:message]

    @status = 1
    #si c'est vide, on accède à la page depuis l'onglet, sinon depuis créer
    if @playlistcode.nil?
      @status = 2
    else
      @status = 3
    end

    @status2 = 1
    #si ya un message, on affiche le message
    if @message == 'updated'
      @status2 = 2
    elsif @message == 'deleted'
      @status2 = 3
    end

  end

  #ajoute une liste a la db
  def add
    #init les values
    #mylist = ""
    mylisttitle = ""

    #set les lists(string;string;string;...) avec les params recu de ajax
    params.each do |key, value|
      if key != "action" and key != "controller"
        #mylist << value << ";"
        mylisttitle << key << ";"
      end
    end

    #verifie que la liste n'est pas vide
    if mylisttitle.empty?
      # liste est vide
      return
    end

    #ajoute la list
    playlist = List2.new(title: mylisttitle)
    playlist.save
  end
  
  #joue les video par argument get
  def play

    #headers.delete 'Set-Cookie'
    #Rack::Utils.delete_cookie_header!(headers, '_datplaylist_session')

    #recupere le premier arg (id de la playlist)
    @id = params[:id]
    if @id.to_i > List2.count
      #invalid playlist
      return
    end
    #recupere la playlist par l'id
    playlist = List2.find_by(link_id: @id)

    #separe la playlist en 2 list, titre et videoid
    #mylist = playlist.list.split(";")
    @mylisttitle = playlist.title.split(";")
    
    #recupere le deuxieme arg (num de la video dans la playlist)
    @n = params[:n].to_i
    if @n > @mylisttitle.count - 1 or @n < 0
      #invalid videoid
      return
    end
    #@videoid = mylist[@n]
    @title = @mylisttitle[@n]

    #verifie si c'est la fin
    @n = @n + 1
    if @n > @mylisttitle.count - 1
      #end of playlist
      @end = 1
      return
    end
    @end = 0


  end

  def verify

    @previous_area = ""
    @previous_author = ""
    @previous_description = ""

    #recup les params
    mylist = params['area-playlist'].delete("\r").split("\n")
    mylist.each do |s|
      s.gsub!(';', ' ')
    end
    mylist.reject! { |c| c.blank? }

    @status = 1
    #temporaire pour tester sans le captcha!!!!!!!!!!!!!!!!!!!!!!!!!
    if verify_recaptcha() and !mylist.empty?
     #if 1 == 1
      @status = 2

      mylisttitle = ""
      mylist.each { |x| mylisttitle << x << ";" }

      #pour le reste
      myauthor = params['author-playlist']
      mydescription = params['description-playlist']

      #verifie la taille des champs au cas ou il ignore la limite coté client
      if mylisttitle.length > 3200 or myauthor.length > 105 or mydescription.length > 105
        @status = 5
        @previous_area = params['area-playlist']
        @previous_author = params['author-playlist']
        @previous_description = params['description-playlist']
        render 'index'
        return
      end

      #le code pr delete/edit
      @mydeletecode = (0...8).map { (65 + rand(26)).chr }.join
      @mylinkid = (0...11).map { (65 + rand(26)).chr }.join

      #ajoute la list
      playlist = List2.new(title: mylisttitle, author: myauthor, description: mydescription, delete_code: @mydeletecode, link_id: @mylinkid)
      playlist.save

      #@playlists = List2.all
      #render 'lists'
      redirect_to controller: 'home', action: 'lists', code: @mydeletecode
    elsif mylist.empty?
      @status = 3

      @previous_author = params['author-playlist']
      @previous_description = params['description-playlist']

      render 'index'
    else
      @status = 4

      @previous_area = params['area-playlist']
      @previous_author = params['author-playlist']
      @previous_description = params['description-playlist']

      render 'index'
    end

  end

  def edit_search
  end

  def edit_search_verify
    redirect_to controller: 'home', action: 'edit', code: params['code-playlist']
  end

  def edit

    #récupération de la playlist
    @code = params[:code]
    puts @code
    @playlists = List2.where(delete_code: @code)

    @status = 0
    if @playlists[0].nil?
      @status = 1 #aucun résultat trouvé
    else
      @status = 2 #playlist trouvée
    end

  end

  def edit_verify

    #verifie si c update ou delete
    mytype = params['submit-type']
    if mytype == "update"
      #update

      #recup les params
      mylist = params['area-playlist'].delete("\r").split("\n")
      mylist.each do |s|
        s.gsub!(';', ' ')
      end
      mylist.reject! { |c| c.blank? }

      #temporaire pour tester sans le captcha!!!!!!!!!!!!!!!!!!!!!!!!!
      if verify_recaptcha() and !mylist.empty?
      #if 1 == 1
        mylisttitle = ""
        mylist.each { |x| mylisttitle << x << ";" }

        #pour le reste
        mycode = params['code-playlist']
        myauthor = params['author-playlist']
        mydescription = params['description-playlist']

        #verifie la taille des champs au cas ou il ignore la limite coté client
        if mylisttitle.length > 3200 or myauthor.length > 105 or mydescription.length > 105
          @status = 5
          redirect_to controller: 'home', action: 'edit', code: params['code-playlist']
          return
        end

        #ajoute la list
        playlist = List2.find_by(delete_code: mycode)
        playlist.update(title: mylisttitle, author: myauthor, description: mydescription)

        #@playlists = List2.all
        #render 'lists'
        redirect_to controller: 'home', action: 'lists', message: 'updated'
      else
        redirect_to controller: 'home', action: 'edit', code: params['code-playlist']
      end
    else
      #delete

      mycode = params['code-playlist']
      List2.destroy_all(delete_code: mycode)
      redirect_to controller: 'home', action: 'lists', message: 'deleted'
    end

  end

  def faq
  end

end
