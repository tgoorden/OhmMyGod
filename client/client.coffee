Meteor.subscribe 'messageboard'

Meteor.startup ->
  Accounts.ui.config({passwordSignupFields:'USERNAME_ONLY'})

Session.setDefault('last_vote',Date.now())
Session.setDefault('view_history',false)

Template.content.message = -> Messageboard.findOne({},{sort:{sticky:-1,votes:-1,created:-1}})

Template.content.view = -> Session.get('view_history')

Template.message.currentSticky = -> Messageboard.findOne({sticky:true})

Template.history.messages = -> Messageboard.find({},{sort:{created:-1}})

Template.content.events =
  'click #view_history': (event,template) ->
     view = Session.get('view_history')
     Session.set('view_history',!view)
     return

Template.addText.events =
  'click #saveText': (event,template) ->
  	text = template.find('#message').value
  	style = template.find('#style').value
  	Messageboard.insert({'text':text,'style':style,'created': Date(),'votes': 1})
  	template.find('#message').value = ''
  	return
  	
Template.addImage.events =
   'click #saveImage': (event,template) ->
      url = template.find('#url').value
      Messageboard.insert({'url':url,'created': Date(),'sticky':false,'votes': 1})
      template.find('#url').value = ''
      return
  	   
Template.message.events =
  'click .delete': (event,template) ->
     id = event.target.attributes['mongo_id'].value
     Messageboard.remove({'_id':id})
     return
  'click .non-sticky': (event,template) ->
     id = event.target.attributes['mongo_id'].value
     Meteor.call 'stick', id, (error) ->
        if (error)
          alert error
     return
  'click .sticky': (event,template) ->
     id = event.target.attributes['mongo_id'].value
     Meteor.call 'unstick', id
     return
  'click .upvote': (event,template) ->
     last_vote = Session.get('last_vote')
     time_diff = Date.now() - last_vote
     if (time_diff > 5000)
        id = event.target.attributes['mongo_id'].value
        Messageboard.update({'_id':id},{$inc:{'votes':1}})
        Session.set('last_vote',Date.now())
     else
     	alert 'Woah. Cool it there cowboy.'
     return
  'click .downvote': (event,template) ->
     last_vote = Session.get('last_vote')
     time_diff = Date.now() - last_vote
     if (time_diff > 5000)
        id = event.target.attributes['mongo_id'].value
        Messageboard.update({'_id':id},{$inc:{'votes':-1}})
        Session.set('last_vote',Date.now())
     else
     	alert 'Woah. Cool it there cowboy.'
     return
     
