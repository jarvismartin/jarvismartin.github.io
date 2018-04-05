// The screen space devoted to the User list
var usersArea = document.getElementById('users');
// User JSON as a Key:Value Store
var users = [];
// Add User Card
var addUser = function (user) {
    var card = document.createElement('details');
    card.id = user.login.username; // For production, probably UUID
    card.classList.add('mar15', 'shadow-1', 'card');
    card.innerHTML = "\n    <summary\n      title=\"click to open/close\"\n      style=\"background-image: url(https://lipis.github.io/flag-icon-css/flags/4x3/" + user.nat.toLowerCase() + ".svg); -webkit-background-size: cover; -moz-background-size: cover; -o-background-size: cover; background-size: cover;\"\n    >\n      <img\n        src=\"" + user.picture.medium + "\"\n        alt=\"user thumbnail photo\"\n        class=\"mar15\"\n      >\n      <div class=\"pad15 nameWrap\">\n        <div class=\"\">\n          " + (user.name.first[0].toUpperCase() + user.name.first.substr(1)) + "\n        </div>\n        <div class=\"\" style=\"margin-left: 10px\">\n          " + (user.name.last[0].toUpperCase() + user.name.last.substr(1)) + "\n        </div>\n      </div>\n    </summary>\n    <div class=\"subcardWrap\">\n      <div class=\"mar15 pad15 subcard\">\n        <h2 style=\"text-align: center;\"> Contact Info </h2>\n        <div class=\"pad15 flex\">\n          <div class=\"label\"> Email: </div>\n          <div style=\"margin-left: 10px; font-weight: bold;\">\n            <a href=\"mailto:" + user.email + "\">\n              " + user.email + "\n            </a>\n          </div>\n        </div>\n        <div class=\"pad15 flex\">\n          <div class=\"label\"> Phone: </div>\n          <div style=\"margin-left: 10px; font-weight: bold;\">\n            <a href=\"tel:" + user.phone + "\">\n              " + user.phone + "\n            </a>\n          </div>\n        </div>\n        <div class=\"pad15 flex\">\n          <div class=\"label\"> Mobile: </div>\n          <div style=\"margin-left: 10px; font-weight: bold;\">\n            <a href=\"tel:" + user.cell + "\">\n              " + user.cell + "\n            </a>\n          </div>\n        </div>\n      </div>\n\n      <div class=\"mar15 pad15 subcard\">\n        <h2 style=\"text-align: center;\"> Location </h2>\n        <address style=\"font-weight: bold;\">\n          <div class=\"pad15\">\n            " + (user.location.street[0].toUpperCase() + user.location.street.substr(1)) + "\n          </div>\n          <div class=\"pad15\">\n            " + (user.location.city[0].toUpperCase() + user.location.city.substr(1)) + "\n          </div>\n          <div class=\"pad15\">\n            " + (user.location.state[0].toUpperCase() + user.location.state.substr(1)) + "\n          </div>\n          <div class=\"pad15\">\n            " + user.location.postcode + "\n          </div>\n        </address>\n      </div>\n\n      <div class=\"mar15 pad15 subcard\">\n        <h2 style=\"text-align: center;\"> Member Info </h2>\n        <div class=\"pad15 flex\">\n          <div class=\"label\"> Member Since: </div>\n          <div style=\"margin-left: 10px; font-weight: bold;\"> " + user.registered + " </div>\n        </div>\n        <div class=\"pad15 flex\">\n          <div class=\"label\"> Birthday: </div>\n          <div style=\"margin-left: 10px; font-weight: bold;\"> " + user.dob + " </div>\n        </div>\n      </div>\n    </div>\n  ";
    usersArea.appendChild(card);
};
// Actually display User info on screen
var showUsers = function (users) {
    for (var _i = 0, users_1 = users; _i < users_1.length; _i++) {
        var user = users_1[_i];
        addUser(user);
    }
};
// Get a new group of Users
var getUsers = function () {
    // Clear User List
    usersArea.innerHTML = "\n    <i class=\"fas fa-spinner fa-spin fa-4x\" style=\"margin: auto;\"></i>\n  ";
    // Get the number from user input
    var num = document.getElementById('userNum').value;
    // Validate the number
    if (parseInt(num) === NaN) {
        return console.error(num + ' is not a number');
    }
    // Fetch that number of Users
    fetch('https://randomuser.me/api/?results=' + num)
        .then(function (response) {
        return response.json();
    })
        .then(function (myJson) {
        console.log(myJson);
        users = myJson.results;
        // Clear User List
        usersArea.innerHTML = '';
        return showUsers(users);
    });
};
// Initial users fetch
getUsers();
