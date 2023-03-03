# Cypher - Smart IOT Based Door Lock System


Software:

Qr Code for Cypher App:


![image](https://user-images.githubusercontent.com/105850133/222675020-11c2b354-267e-48bc-ad8b-ac1965d719ff.png)


Notification:


![image](https://user-images.githubusercontent.com/105850133/222673399-47660708-e105-40b0-8f6e-6525094c830f.png)


Main flow chart:


![Main flow chart](https://user-images.githubusercontent.com/105850133/221357025-96593c11-108c-4216-aac8-47f311b5ed72.png)


LoginPage:

![image](https://user-images.githubusercontent.com/105850133/222673805-58d04940-22bf-4c5b-bafd-68348947cb1c.png)
![image](https://user-images.githubusercontent.com/105850133/222673826-d8138060-9874-4470-a14f-aa5c4b47fba5.png)
![image](https://user-images.githubusercontent.com/105850133/222673847-3c49590b-5c6f-4f24-bb52-5b0f579707a6.png)

![LOGIN PAGE](https://user-images.githubusercontent.com/105850133/221357028-d018f542-6bb2-4dc6-9374-3fecc7a85372.png)

Navigation bar :


![image](https://user-images.githubusercontent.com/105850133/222673974-e8b8b7d5-4dba-4ad0-8815-99db35914e3a.png)


MonitorPage:


![image](https://user-images.githubusercontent.com/105850133/222674041-3eaebbae-d871-4ef5-be21-d461708f8306.png)

![Monitor Page](https://user-images.githubusercontent.com/105850133/221357022-f5d8f10f-bd69-49f0-8b9b-811135e90dd0.png)


Profiles Page:


![image](https://user-images.githubusercontent.com/105850133/222675996-e2f91eef-b24b-4d81-8cb9-c5cbd1ffd462.png)

![image](https://user-images.githubusercontent.com/105850133/222674211-897caee6-0874-447f-9554-408f3b41977f.png)

![image](https://user-images.githubusercontent.com/105850133/222674252-2f08b126-a884-42c3-9fa1-a28ce2e9ce26.png)

![image](https://user-images.githubusercontent.com/105850133/222674290-ec6d0db8-f159-4bfa-a19b-4230a4858c29.png)

![image](https://user-images.githubusercontent.com/105850133/222674317-6d390de5-d01f-42da-a846-519774f280d1.png)

![image](https://user-images.githubusercontent.com/105850133/222674336-36796e7a-1e01-418b-aa1b-1dfc53f722e5.png)

![image](https://user-images.githubusercontent.com/105850133/222674404-ab9a8e75-deb1-462b-9e81-54c05948a512.png)

![image](https://user-images.githubusercontent.com/105850133/222674426-0ac9013f-c0c3-469e-87a9-5a39a45860d1.png)

![image](https://user-images.githubusercontent.com/105850133/222674454-e5554080-b27d-461a-972e-e4e4af090363.png)

![fingerprint ](https://user-images.githubusercontent.com/105850133/221357082-2aff8df4-f63a-4f69-9b56-62d058bd494f.png)



HistoryPage:


![image](https://user-images.githubusercontent.com/105850133/222674518-cc3b073e-c5b4-4ab2-b248-f73f0b1db37c.png)

![image](https://user-images.githubusercontent.com/105850133/222674551-8883c8be-e542-4428-b5ed-d55ab7439daa.png)

![History Page](https://user-images.githubusercontent.com/105850133/221357046-78ca79ec-a17a-42dc-964a-c3358e338676.png)


SettingsPage:


![image](https://user-images.githubusercontent.com/105850133/222674725-1cc43743-345a-4871-8965-0804cde29b39.png)

![image](https://user-images.githubusercontent.com/105850133/222674749-a715cb8f-0088-46d1-9ede-747a1cfab94f.png)

![Settings page](https://user-images.githubusercontent.com/105850133/221356974-2859319f-ae5e-469d-b035-7ddaa0f2499d.png)






Hardware:

![project pic](https://user-images.githubusercontent.com/105850133/221356707-f70a0efc-e83d-4dc2-a66c-bd78a1ba851e.jpg)
![back project view](https://user-images.githubusercontent.com/105850133/221356735-7bf1ad5b-a74b-4392-b7f5-14bfdc4af270.jpg)
![close view ](https://user-images.githubusercontent.com/105850133/221356737-7d4a4883-b885-4477-a1e3-52962110fba6.jpg)


Schametic:

![schametic](https://user-images.githubusercontent.com/105850133/221356991-eff071e3-9596-4c89-a1ed-68f8efcd5d35.jpg)


Firebase:

![firebase](https://user-images.githubusercontent.com/105850133/221357078-03a48fda-989f-4357-9b37-b15c7ae19a9b.png)

distance: displays the ultrasonic distance (in cm) received from the NodeMCU esp8266.
doorLocked: displays the status of the door lock and allows the user to lock and unlock the door from the app.
motion: displays the status of motion detection and sends notifications to the user if motion is detected. And makes the distance display also.
option: by default, it is set to 2, but when the user wants to add a fingerprint, the app updates this node to 1 to set up a new fingerprint. When the setup is complete, the node is updated back to 2. 1 is for scanning a new fingerprint and 2 is for verifying the fingerprint to open the door lock.
Id: the ID that will be sent for the fingerprint sensor when entered to save the fingerprint on it.
profiles: consists of all home profiles with a different profile key for each profile. Each profile has a name and a list of fingerprints.
Fingerprints under profilekeys: each fingerprint ID is saved under different fingerkeys. When a new fingerprint is added, it is updated in the fingerprints list under that profile and it is also updated in the node ‘Id’ to send it to fingerprint sensor , so it is easier and faster for to identify update.
savedID: displays the fingerprint of the user who entered the home. After some time, it is updated back to zero. The app takes the ID and searches for it among all fingerprints under all profiles to find out who came home and returns the profile name and the date and time to ‘history’ node.
history: saves a list of data entries for different profiles with the data time when the fingerprint ID is sent to "savedID".
steps: for the fingerprint stepper widget, it updates the node with 1, then 2, then 3, then either 4 or 5 to guide the user through the fingerprint setup process. It informs the user if the setup was successful or failed at the end.or the fingerprint stepper widget, it updates node with 1 then 2 then 3 then either 4 or 5 to guide user to setup fingerprint and so at the end tells him if success or failed.


Wifi Server:

![wifi server flow chart](https://user-images.githubusercontent.com/105850133/221356976-bc0f318e-8b99-4c42-b617-8f4b737b86ec.png)
![wifi server from phone](https://user-images.githubusercontent.com/105850133/221356973-d898f358-429d-4c1b-a5a0-e1caa70570f5.jpg)
![list of networks in server](https://user-images.githubusercontent.com/105850133/221357040-980a1f42-a6f0-4e1b-ac45-dd5903299cef.jpg)
![from arduino connection to internet via server](https://user-images.githubusercontent.com/105850133/221357071-11d8b7cb-c41b-41ae-b988-da654fb51d85.jpg)


