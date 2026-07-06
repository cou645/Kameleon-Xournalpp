// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'de';

  static String m0(error) =>
      "Bild-Hintergrund konnte nicht gesetzt werden: ${error}";

  static String m1(error) =>
      "PDF-Hintergrund konnte nicht gesetzt werden: ${error}";

  static String m2(error) => "PDF-Export fehlgeschlagen: ${error}";

  static String m3(path) => "PDF exportiert nach ${path}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "abort": MessageLookupByLibrary.simpleMessage("Abbrechen"),
    "about": MessageLookupByLibrary.simpleMessage("About"),
    "aboutXournal": MessageLookupByLibrary.simpleMessage("Über Xournal++"),
    "aboutXournalMobileEdition": MessageLookupByLibrary.simpleMessage(
      "Über Xournal++ Mobile",
    ),
    "addLayer": MessageLookupByLibrary.simpleMessage("Ebene hinzufügen"),
    "addPage": MessageLookupByLibrary.simpleMessage("Seite einfügen"),
    "apply": MessageLookupByLibrary.simpleMessage("Anwenden"),
    "areYouSureIHaveThePermissionAndAreYou": MessageLookupByLibrary.simpleMessage(
      " leider nicht lesen. Bist du dir sicher, dass ich dazu die Berechtigung habe, und, dass es eine richtige Xournal++ Datei ist?",
    ),
    "areYouSureToDeleteTheSelectedFileThisCannot":
        MessageLookupByLibrary.simpleMessage(
          "Bist du dir sicher, dass du die Datei löschen möchtest? Das kann nicht rückgängig gemacht werden..",
        ),
    "background": MessageLookupByLibrary.simpleMessage("Hintergrund"),
    "between1And": MessageLookupByLibrary.simpleMessage("Zwischen 1 und"),
    "cancel": MessageLookupByLibrary.simpleMessage("Abbrechen"),
    "close": MessageLookupByLibrary.simpleMessage("Schließen"),
    "color": MessageLookupByLibrary.simpleMessage("Farbe"),
    "colorAndThickness": MessageLookupByLibrary.simpleMessage("Farbe & Dicke"),
    "confirmDelete": MessageLookupByLibrary.simpleMessage("Lösche bestätigen"),
    "copied": MessageLookupByLibrary.simpleMessage("Kopiert"),
    "copyErrorMessage": MessageLookupByLibrary.simpleMessage(
      "Fehlermeldung kopieren",
    ),
    "couldNotSetImageBackground": m0,
    "couldNotSetPdfBackground": m1,
    "delete": MessageLookupByLibrary.simpleMessage("Löschen"),
    "deletePage": MessageLookupByLibrary.simpleMessage("Seite löschen"),
    "dotted": MessageLookupByLibrary.simpleMessage("Gepunktet"),
    "doubleTapToChange": MessageLookupByLibrary.simpleMessage(
      "Doppelt tippen zum Ändern.",
    ),
    "dropFilesToOpen": MessageLookupByLibrary.simpleMessage(
      "Dateien zum Öffnen hier hinschieben",
    ),
    "eraser": MessageLookupByLibrary.simpleMessage("Radierer"),
    "error": MessageLookupByLibrary.simpleMessage("Fehler"),
    "errorLoadingFile": MessageLookupByLibrary.simpleMessage(
      "Fehler beim Öffnen der Datei",
    ),
    "errorOpeningFile": MessageLookupByLibrary.simpleMessage(
      "Fehler beim Öffnen der Datei",
    ),
    "exportPdf": MessageLookupByLibrary.simpleMessage("PDF exportieren"),
    "graph": MessageLookupByLibrary.simpleMessage("Zeichnen"),
    "highlighter": MessageLookupByLibrary.simpleMessage("Textmarker"),
    "home": MessageLookupByLibrary.simpleMessage("Startseite"),
    "imVerySorryButICouldntReadTheFile": MessageLookupByLibrary.simpleMessage(
      "Es tut mir Leid, aber ich konnte die Datei ",
    ),
    "image": MessageLookupByLibrary.simpleMessage("Bild"),
    "importPdf": MessageLookupByLibrary.simpleMessage("PDF importieren"),
    "latexNotImplemented": MessageLookupByLibrary.simpleMessage(
      "LaTeX (nicht implementiert)",
    ),
    "layerName": MessageLookupByLibrary.simpleMessage("Ebenenname"),
    "layers": MessageLookupByLibrary.simpleMessage("Ebenen"),
    "lined": MessageLookupByLibrary.simpleMessage("Liniert"),
    "loadingFile": MessageLookupByLibrary.simpleMessage("Lade Datei..."),
    "manageLayers": MessageLookupByLibrary.simpleMessage("Ebenen verwalten"),
    "mb": MessageLookupByLibrary.simpleMessage("MB"),
    "mobileEditionUnofficial": MessageLookupByLibrary.simpleMessage(
      "offizielle Mobil-App",
    ),
    "move": MessageLookupByLibrary.simpleMessage("Bewegen"),
    "movePage": MessageLookupByLibrary.simpleMessage("Seite verschieben"),
    "newDocument": MessageLookupByLibrary.simpleMessage("Neues Dokument"),
    "newFile": MessageLookupByLibrary.simpleMessage("Neu"),
    "newNotebook": MessageLookupByLibrary.simpleMessage("Neues Notizbuch"),
    "newPageIndex": MessageLookupByLibrary.simpleMessage(
      "Neue Position der Seite",
    ),
    "newTitle": MessageLookupByLibrary.simpleMessage("Neuer Titel"),
    "noFileSelected": MessageLookupByLibrary.simpleMessage(
      "Keine Datei gewählt",
    ),
    "noRecentFiles": MessageLookupByLibrary.simpleMessage(
      "Keine zuletzt verwendeten Dateien.",
    ),
    "notImplemented": MessageLookupByLibrary.simpleMessage(
      " (nicht implementiert)",
    ),
    "notWorkingYet": MessageLookupByLibrary.simpleMessage(
      "Funktioniert noch nicht.",
    ),
    "okay": MessageLookupByLibrary.simpleMessage("Okay"),
    "open": MessageLookupByLibrary.simpleMessage("Öffnen"),
    "openNavigation": MessageLookupByLibrary.simpleMessage("Navigation öffnen"),
    "opening": MessageLookupByLibrary.simpleMessage("Öffne"),
    "openingFile": MessageLookupByLibrary.simpleMessage("Öffne Datei"),
    "pageBackground": MessageLookupByLibrary.simpleMessage("Hintergrund"),
    "pageNumber": MessageLookupByLibrary.simpleMessage("Seitennummer"),
    "pdf": MessageLookupByLibrary.simpleMessage("PDF"),
    "pdfExportFailed": m2,
    "pdfExportedTo": m3,
    "pdfPage": MessageLookupByLibrary.simpleMessage("PDF-Seite"),
    "pen": MessageLookupByLibrary.simpleMessage("Stift"),
    "quota": MessageLookupByLibrary.simpleMessage("Speicher"),
    "recentFiles": MessageLookupByLibrary.simpleMessage(
      "Zuletzt verwendete Dokumente",
    ),
    "renameLayer": MessageLookupByLibrary.simpleMessage("Ebene umbenennen"),
    "renderingPdf": MessageLookupByLibrary.simpleMessage("PDF wird erstellt…"),
    "ruled": MessageLookupByLibrary.simpleMessage("Liniert mit Rand"),
    "save": MessageLookupByLibrary.simpleMessage("Speichern"),
    "saveAs": MessageLookupByLibrary.simpleMessage("Speichern unter..."),
    "savingFile": MessageLookupByLibrary.simpleMessage("Speichere Datei..."),
    "select": MessageLookupByLibrary.simpleMessage("Auswählen"),
    "selectColor": MessageLookupByLibrary.simpleMessage("Farbe wählen"),
    "selectNotImplemented": MessageLookupByLibrary.simpleMessage(
      "Auswählen (nicht implementiert)",
    ),
    "setDocumentTitle": MessageLookupByLibrary.simpleMessage(
      "Titel des Dokuments ändern",
    ),
    "sharePage": MessageLookupByLibrary.simpleMessage("Seite teilen..."),
    "sourceCode": MessageLookupByLibrary.simpleMessage("Quellcode"),
    "strokeWidth": MessageLookupByLibrary.simpleMessage("Stiftstärke:"),
    "successfullySaved": MessageLookupByLibrary.simpleMessage(
      "Erfolgreich gespeichert.",
    ),
    "successfullyShared": MessageLookupByLibrary.simpleMessage(
      "Erfolgreich geteilt:",
    ),
    "textNotImplemented": MessageLookupByLibrary.simpleMessage(
      "Text (nicht implementiert)",
    ),
    "theFollowingErrorWasDetected": MessageLookupByLibrary.simpleMessage(
      "Folgender Fehler ist aufgetreten:",
    ),
    "thereWereNoMorePagesWeAddedOne": MessageLookupByLibrary.simpleMessage(
      "Es waren keine Seiten mehr übrig. Wir haben eine hinzugefügt.",
    ),
    "tool": MessageLookupByLibrary.simpleMessage("Werkzeug"),
    "toolboxNotImplementedYet": MessageLookupByLibrary.simpleMessage(
      "Werkzeugkasten noch nicht implementiert.",
    ),
    "tools": MessageLookupByLibrary.simpleMessage("Werkzeuge"),
    "unfortunatelyThereWasAnErrorSavingThisFile":
        MessageLookupByLibrary.simpleMessage(
          "Leider gab es ein Problem beim Speichern dieser Datei.",
        ),
    "used": MessageLookupByLibrary.simpleMessage("verwendet"),
    "whiteout": MessageLookupByLibrary.simpleMessage("Korrektur"),
    "whiteoutEraserNotImplemented": MessageLookupByLibrary.simpleMessage(
      "Killer (nicht implementiert)",
    ),
    "xournalMobileEditionIsAnUnofficialProjectTryingToMake":
        MessageLookupByLibrary.simpleMessage(
          "Xournal++ Mobile ist ein Projekt, das es versucht, Xournal++ Dateien und -Funktionen auf anderen Geräten bereitzustellen.",
        ),
    "youDidNotSelectAnyFile": MessageLookupByLibrary.simpleMessage(
      "Du hast keine Datei ausgewählt..",
    ),
    "youveBeenRedirectedToTheLocalApp": MessageLookupByLibrary.simpleMessage(
      "Du wurdest in die lokale App weitergeleitet.",
    ),
  };
}
