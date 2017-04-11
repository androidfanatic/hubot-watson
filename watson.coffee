watson = require 'watson-developer-cloud'

# Configure parameters for IBM watson conversation service

config = {
  username: ''
  password: '',
  workspace_id: ''
}

context = {}

conversation = watson.conversation {
  username: config.username,
  password: config.password,
  version: 'v1',
  version_date: '2017-02-03'
}

module.exports = (robot) ->
  robot.hear /(.+)/i, (res) ->
    msg = res.match[0].replace res.robot.name+' ', ''
    msg = msg.replace /^\s+/, ''
    msg = msg.replace /\s+&/, ''
    conversation.message {
      workspace_id: config.workspace_id,
      input: {'text': msg},
      context: context
    },  (err, response) ->
      if err
        res.send err
      else
        console.log JSON.stringify response, null, 2
        res.send response.output.text.join '. '
        context = response.context
    
