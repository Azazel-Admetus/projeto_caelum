/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

// Wait for the deviceready event before using any of Cordova's device APIs.
// See https://cordova.apache.org/docs/en/latest/cordova/events/events.html#deviceready
document.addEventListener('deviceready', onDeviceReady, false);

function onDeviceReady() {
    // Cordova is now initialized. Have fun!

    console.log('Running cordova-' + cordova.platformId + '@' + cordova.version);
    document.getElementById('deviceready').classList.add('ready');
}
document.addEventListener("DOMContentLoaded", () => {
    const button = document.getElementById("mainButton");
    const ring = document.getElementById("ring");

    let expanded = false;

    button.addEventListener("click", () => {
        expanded = !expanded;

        if (expanded) {
            // expande o botão
            button.style.transform = "scale(1.2)";

            // ativa o anel
            ring.style.opacity = "1";
            ring.classList.add("spin");
        } else {
            // volta ao normal
            button.style.transform = "scale(1)";

            // desativa o anel
            ring.style.opacity = "0";
            ring.classList.remove("spin");
        }
    });
});
