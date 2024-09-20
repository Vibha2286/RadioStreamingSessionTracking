# Radio Streaming Session Tracking

![Simulator Screenshot - iPhone 15 - 2024-09-20 at 12 26 50](https://github.com/user-attachments/assets/ce47e174-e351-4e5d-bf5a-7f69b02a752d)

![Simulator Screenshot - iPhone 15 - 2024-09-20 at 12 26 56](https://github.com/user-attachments/assets/01787ca6-4413-432a-a6a0-92b4a7e8dd8c)


## Overview

This project is a radio streaming session manager that allows users to manage multiple streaming sessions, track their durations, and visualize overlapping sessions in a timeline view. The complete streaming session implementation consists of managing multiple RadioSession instances, visualizing them through a TimelineView, and calculating both total and effective streaming durations. The aim is to create an intuitive UI that accurately reflects streaming activities, including handling overlaps between sessions.

## Features

- Add, remove, and fetch streaming sessions.
- Calculate total streaming time and effective streaming time after accounting for overlaps.
- Visual representation of sessions in a timeline format with animations.
- Supports simultaneous streaming from multiple devices.
- Overlapped session is in differnt colours 

## Technologies Used
- Swift
- SwiftUI
- Combine

## Getting Started

### Prerequisites
- Xcode (version 12 or later)
- macOS (version 11 or later)


## Challeages Faced

- Handling overlapping session logic efficiently.
- Ensuring accurate time calculations across various sessions.
- Creating a responsive and user-friendly UI in SwiftUI.

## Assumptions Made

- All input times are valid and within a reasonable range.
- Users have a basic understanding of how to navigate the application.
- The implementation assumes sessions are contained within a single day, focusing on hour and minute accuracy.
- The input data for sessions is assumed to be correctly formatted and does not require validation.


## Conclusion

The complete streaming session implementation effectively manages and visualizes radio streaming activities. By addressing challenges related to overlap detection and dynamic layout, the solution provides an accurate and user-friendly experience. Extensive testing ensures reliability and accuracy in duration calculations, making it a robust tool for tracking streaming sessions.
