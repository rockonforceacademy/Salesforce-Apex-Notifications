trigger SendNotification on Account (before insert) {
    SendNotification.Send();
}