var lock = new Auth0Lock(AUTH0_CLIENT_ID, AUTH0_DOMAIN);

lock.show({
  callbackURL: 'http://localhost:3000/callback'
});

function alertMessage(text) {
    alert(text)
}

window.logger = (flutter_value) => {
   console.log({ js_context: this, flutter_value });
}

