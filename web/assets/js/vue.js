(function() {
  let Utils = {
    solveURL: function() {
      let protocol = 'ws://';

      if(window.location.protocol == 'https:') {
        protocol = 'wss://';
      }

      return protocol + window.location.host + '/ws';
    },
    getDate: function() {
      let date = new Date();
      let hours = date.getHours();
      let minutes = date.getMinutes();

      if(hours < 10) {
        hours = '0' + hours;
      }

      if(minutes < 10) {
        minutes = '0' + minutes;
      }

      return hours + ':' + minutes;
    }
  };

  let chat = new Vue({
    el: '#chat',
    data: {
      username: '',
      message: '',
      ws: null,
      connected: false,
      members: [],
      messages: []
    },
    methods: {
      addMessage: function(username, date, content) {
        let message = {type: 'message', username: username, date: date, content: content};
        this.messages.push(message);
      },
      addMessageMember: function(username, content, icon) {
        let messageMember = {type: 'member', icon: icon, username: username, content: content};
        this.messages.push(messageMember);
      },
      updateMembers: function(members) {
        this.members = members;
      },
      sendMessage: function() {
        if( ! this.ws ) {
          alert('Not connected!');
        }

        if( !this.message.trim() ){
          return false;
        }

        this.send('talk', {message: this.message});
      },
      connect: function(event) {
        this.ws = new WebSocket( Utils.solveURL() );
        this.ws.onopen = this.onOpen;
        this.ws.onmessage = this.onMessage;
        this.ws.onclose = this.onClose;
      },
      send: function(action, data){
        this.ws.send(JSON.stringify({
          action: action,
          data: data
        }));

        this.message = '';
      },
      onOpen: function() {
        this.connected = true;

        this.send('join', {room: 'geral', username: this.username});
      },
      onMessage: function(e) {
        let data = JSON.parse(e.data);

        if( data.action == "message" ) {
          data.date = Utils.getDate();
          this.addMessage(data.username, data.date, data.content);
        }
        else if( data.action == "join" ) {
          this.addMessageMember(data.username, data.content, data.action);
        }
        else if( data.action == 'leave' ) {
          this.addMessageMember(data.username, data.content, data.action)
        }
        else if( data.action == 'online' ) {
          this.updateMembers(data.content);
        }
      },
      onClose: function() {
        this.message = '';
        this.messages = [];
        this.members = [];
        this.ws = null;

        this.connected = false;
      }
    }
  });

  chat.connected = true;
  chat.members = [
    'Lucas Ramos',
    'Mateus Ramos',
    'Sylviot',
    'Lucas Ramos',
    'Mateus Ramos',
    'Sylviot',
    'Lucas Ramos',
    'Mateus Ramos',
    'Sylviot',
    'Lucas Ramos',
    'Mateus Ramos',
    'Sylviot',
    'Lucas Ramos',
    'Mateus Ramos',
    'Sylviot',
    'Lucas Ramos',
    'Mateus Ramos',
    'Sylviot',
    'Lucas Ramos',
    'Mateus Ramos',
    'Sylviot'
  ];

  chat.addMessage('Lucas Ramos', '21/11/2016', 'Olá');
  chat.addMessage('Lucas Ramos', '21/11/2016', 'Olá');
  chat.addMessage('Lucas Ramos', '21/11/2016', 'Olá');
  chat.addMessage('Lucas Ramos', '21/11/2016', 'Olá');
  chat.addMessage('Lucas Ramos', '21/11/2016', 'Olá');
  chat.addMessage('Lucas Ramos', '21/11/2016', 'Olá');
  chat.addMessage('Lucas Ramos', '21/11/2016', 'Olá');
  chat.addMessage('Lucas Ramos', '21/11/2016', 'Olá');
  chat.addMessage('Lucas Ramos', '21/11/2016', 'Olá');
  chat.addMessage('Lucas Ramos', '21/11/2016', 'Olá');

}());
