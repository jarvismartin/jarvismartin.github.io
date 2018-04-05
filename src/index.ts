// The screen space devoted to the User list
const usersArea = document.getElementById('users');

// User JSON as a Key:Value Store
let users: any = [];

// Add User Card
let addUser = (user: any) => {

  let card = document.createElement('details');
  card.id = user.login.username; // For production, probably UUID
  card.classList.add('mar15', 'shadow-1', 'card');
  card.innerHTML = `
    <summary
      title="click to open/close"
      style="background-image: url(https://lipis.github.io/flag-icon-css/flags/4x3/${user.nat.toLowerCase()}.svg); -webkit-background-size: cover; -moz-background-size: cover; -o-background-size: cover; background-size: cover;"
    >
      <img
        src="${user.picture.medium}"
        alt="user thumbnail photo"
        class="mar15"
      >
      <div class="pad15 nameWrap">
        <div class="">
          ${user.name.first[0].toUpperCase() + user.name.first.substr(1)}
        </div>
        <div class="" style="margin-left: 10px">
          ${user.name.last[0].toUpperCase() + user.name.last.substr(1)}
        </div>
      </div>
    </summary>
    <div class="flex subcardWrap">
      <div class="mar15 pad15 subcard">
        <h2 style="text-align: center;"> Contact Info </h2>
        <div class="pad15 flex">
          <div class="label"> Email: </div>
          <div style="margin-left: 10px; font-weight: bold;">
            <a href="mailto:${user.email}">
              ${user.email}
            </a>
          </div>
        </div>
        <div class="pad15 flex">
          <div class="label"> Phone: </div>
          <div style="margin-left: 10px; font-weight: bold;">
            <a href="tel:${user.phone}">
              ${user.phone}
            </a>
          </div>
        </div>
        <div class="pad15 flex">
          <div class="label"> Mobile: </div>
          <div style="margin-left: 10px; font-weight: bold;">
            <a href="tel:${user.cell}">
              ${user.cell}
            </a>
          </div>
        </div>
      </div>

      <div class="mar15 pad15 subcard">
        <h2 style="text-align: center;"> Location </h2>
        <address style="font-weight: bold;">
          <div class="pad15">
            ${user.location.street[0].toUpperCase() + user.location.street.substr(1)}
          </div>
          <div class="pad15">
            ${user.location.city[0].toUpperCase() + user.location.city.substr(1)}
          </div>
          <div class="pad15">
            ${user.location.state[0].toUpperCase() + user.location.state.substr(1)}
          </div>
          <div class="pad15">
            ${user.location.postcode}
          </div>
        </address>
      </div>

      <div class="mar15 pad15 subcard">
        <h2 style="text-align: center;"> Member Info </h2>
        <div class="pad15 flex">
          <div class="label"> Member Since: </div>
          <div style="margin-left: 10px; font-weight: bold;"> ${user.registered} </div>
        </div>
        <div class="pad15 flex">
          <div class="label"> Birthday: </div>
          <div style="margin-left: 10px; font-weight: bold;"> ${user.dob} </div>
        </div>
      </div>
    </div>
  `;

  usersArea.appendChild(card);
}

// Actually display User info on screen
let showUsers = (users: any) => {
  for(let user of users) {
    addUser(user);
  }
}

// Get a new group of Users
let getUsers = () => {
  // Clear User List
  usersArea.innerHTML = `
    <i class="fas fa-spinner fa-spin fa-4x" style="margin: auto;"></i>
  `;
  // Get the number from user input
  const num = (document.getElementById('userNum') as HTMLInputElement).value;
  // Validate the number
  if (parseInt(num) === NaN ) {
    return console.error(num + ' is not a number');
  }
  // Fetch that number of Users
  fetch('https://randomuser.me/api/?results='+num)
    .then(function(response) {
      return response.json();
    })
    .then(function(myJson) {
      console.log(myJson);
      users = myJson.results;
      // Clear User List
      usersArea.innerHTML = '';
      return showUsers(users);
    });
}

// Initial users fetch
getUsers();
