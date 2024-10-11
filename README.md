# Overview
Trip Journal is a simple app for creating and storing journal entries specifically related to vacations and trips. I have a history of creating these types of journal entries for trips I've been on over the years and was looking for a simple way to keep things all in one place. This app is also a work in progress, and a playground for trying new things. I'm currently working on refining my approach to implementing MVVM architecture while also incorporating a protocol oriented programming approach, IoC and Clean Architecture principles. I also used this app as an opportunity to get a feel for Realm.

# Main App Flow
Overall the flow of the app is fairly simple. It starts on a timeline view that lists the sorted trips by date. From there, the user can tap on a trip, represented by a photo and title, to view more details about that trip. In the Trip detail screen, the user can edit the title, dates and cover photo for the trip, as well as view a list of the days in the trip and add or remove Days. Tapping on one of the listed days will bring the user to the final main screen in the app and display the high level day details (title, date, cover photo) as well as the actual photo and written content that makes up the journal entry. 

<img width="1028" alt="Screenshot 2024-10-11 at 1 21 24 PM" src="https://github.com/user-attachments/assets/8155241c-9f93-4721-a937-7107825c3814">

Adding content is as simple as tapping one of the two buttons at the bottom of the screen and either selecting a photo from the camera roll or typing out written content in the standard way.

<img width="1005" alt="Screenshot 2024-10-11 at 1 41 34 PM" src="https://github.com/user-attachments/assets/43ff94fc-7c2c-4a8f-b150-0f13d52ce332">

# Challenges & Learnings
One of the things I struggled most with in this project was finding the right ways to combine the use of ObservableObjects and Protocols/Dependency Injection at the View layer. After initially avoiding the problem, I eventually found a way to do this using Generics (which is what is implemented now), however this came with a number of new issues that I hadn’t expected. Working through those issues was a great learning experience and I gained considerable insight into leveraging and defining Generics in a variety of different applications. That said, I’m still looking to refine the implementation further and looking for ways to simplify some of the complexity it introduced. 


# What's Next?
I've got a very long list of things I want to add and improve; some of them functional, but many of them under the hood. If nothing else, this project was a reminder for me that most of the work and time is in the apparent details, but also that those details really make a difference to the quality of the code and application. The following are some highlights from my very long todo list:

- Address some view refresh issues with Day and Trip SequenceViewModels
- Add Proper Unit Tests (hopefully coming soon!)
- Refine and improve UI for better Accessibility support
- Handle deletion of photo files when entities are deleted
- Save thumbnail size photos for day list for faster loading
- Replace Trip cover photo with carousel view in main home screen
- Revisit persistence layer and remove instances of try!
- Explore and leverage Swiftlint
- Explore and play around with Swinject
