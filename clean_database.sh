#!/bin/sh
echo "do clean..."
rake db:reset db:migrate
rake db:drop db:create db:migrate
echo "cleaned prod !"
rails g model List2 title:text author:string description:string delete_code:string link_id:string
rake db:migrate
echo "model ok"
