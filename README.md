== Welcome to Battleship by RckStrz

bundle install
bundle generate rspec:install
bundle exec rake db:migrate
bundle exec rake db:test:prepare



story cards finished in iteration 2:
1. A user should be able to see other opponents' fire action and coordinates.
2. Server should be able to PUSH messages to all users within a room.
3. User should be able to login using social network in website Credentials.
4. A user should be able to select the opponent in each fire round.
5. A user should be able to send the ship coordinates to the server via JSON.
6. A user should be able to sign up to create an account.
7. A user should be able to log in.
8. A user should be able to log out.
9. A user should be able to join a room.
10. A user should be able to Leave Room.
11. A user should be able to create a room.
