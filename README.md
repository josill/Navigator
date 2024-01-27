# Navigator: 

## Demo
Full demo of the app, a few comments:
- Apple screen recording automatically hides the password entering and location approving
- One point my location teleports, which demonstrates that you can't cheat. When you move too fast the track is broken off
- The download button, where I enter my email is for downloading your session as GPX format, which is emailed to you

https://github.com/josill/Navigator/assets/113284402/747f224c-13d2-4410-bdc8-64564d3de25f

## Setup:
Mandatory config class variables (./Navigator/Config.swift):
- smtpHostname (the host where your email is located on, f.e smtp.gmail.com)
- smtpEmail (email where we send the gpx data from)
- smtpPassword (for your email)
- backendUrl (for my case it is https://sportmap.akaver.ee)

### Navigator user flow:
![Alt text](./state.svg)

## Useful links:

- [Handling 
NavigationStack 
using a router](https://medium.com/@fmmobilelive/navigating-with-navigationpath-in-swiftui-a-structured-approach-91d31e8939b)

- [Live 
Activities](https://betterprogramming.pub/create-live-activities-with-activitykit-on-ios-16-beta-4766a347035b)

- [SwiftSMTP](https://swiftpackageindex.com/Kitura/Swift-SMTP)
