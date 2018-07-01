/**
 * Fetch API
 * @return an asynchrous request with Promise
 * @rmq [Fetch API polyfill](https://github.com/github/fetch) for IE
 * @see https://developers.google.com/web/updates/2015/03/introduction-to-fetch
 * @rmq to find all the headers fetch('http://example.com').then(function(response) {
for(let header of response.headers) { console.log(header); }
})﻿
 */

function status(response) {  
  if (response.status >= 200 && response.status < 300) {  
    return Promise.resolve(response)  
  } else {  
    return Promise.reject(new Error(response.statusText))  
  }  
}

function json(response) {  
  return response.json()  
}

fetch('http://localhost:8984/gdp/bibliography/items/sauval1724', {
  method: 'get',
  redirect: 'follow',
  headers: new Headers({
    'Content-Type': 'application/json'
  })
})
  .then(status)
  .then(json)
  .then(function(data) {
    console.log('Request succeeded with JSON response', data);
  })
  .catch(function(error) {
  console.log('Request failed', error);
});


