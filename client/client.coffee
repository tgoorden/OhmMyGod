Meteor.subscribe 'messageboard'

Meteor.startup ->
  Accounts.ui.config({passwordSignupFields:'USERNAME_ONLY'})

Session.setDefault('last_vote',Date.now())

Template.content.message = -> Messageboard.findOne({},{sort:{votes:-1,created:-1}})

Template.history.messages = -> Messageboard.find({},{sort:{created:-1}})

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
     message = -> Messageboard.findOne({'_id':id})
     Messageboard.update({'_id':id},{$set:{'sticky':true}})
     return
  'click .sticky': (event,template) ->
     id = event.target.attributes['mongo_id'].value
     message = -> Messageboard.findOne({'_id':id})
     Messageboard.update({'_id':id},{$set:{'sticky':false}})
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