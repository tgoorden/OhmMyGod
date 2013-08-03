Meteor.publish 'messageboard', -> Messageboard.find({})

Meteor.startup ->
   Meteor.setInterval (->
       Messageboard.update({},{$set:{'sticky':false}},{multi:true})
       ), 10000
   Meteor.setInterval (->
       Messageboard.update({'votes': {$gt:0}},{$inc:{'votes':-1}},{multi:true})
       ), 120000

Meteor.methods
   'stick': (id) ->
       Messageboard.update({'_id':id},{$set:{'sticky':true}})
       Messageboard.update {'_id':{$ne:id}},{$set:{'sticky':false}},{multi:true}, (error) ->
         throw error
       return
   'unstick': (id) ->
       Messageboard.update({'_id':id},{$set:{'sticky':false}})
       return
       
weigh = (sum, message) ->
   message.subsum = sum
   return sum + message.votes
