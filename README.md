
Tasting Notes is an iOS app for wine drinkers to keep track of their tasting notes.  What makes Tasting Notes
different then most apps like this is the ability to create custom notebooks.  Users can change the content
and layout of the notebook in the app.  They can also create different types of notebooks if they wish.

The original version of Tasting Notes was powered by a SQLite database and depeneded on SQL, but this version
is being recoded with Core Data.  The user's will be able to create their own notebook schemas.  These schemas are stored as Core Data managed objects.  Core Data is used only with the AppContent class (a Singleton) on the main thread.

The next version of Tasting Notes will be an overhauled version based on Tasting Notes 3 which had been available on the App Store since 2008 (versions 1-3).  Table views will be used to organize the controls and the user interface will be kept to minimun.  In the future, the sections may be organized differently using collection view cells to organize the lists of controls.
