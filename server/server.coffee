Meteor.publish 'messageboard', -> Messageboard.find({})

Meteor.startup ->
   if (!Meteor.users.findOne({'username':'oenie'}))
      Accounts.createUser({'username':'oenie','password':'linda'})
   if (!Meteor.users.findOne({'username':'tgoorden'}))
      Accounts.createUser({'username':'tgoorden','password':'annemarie'})