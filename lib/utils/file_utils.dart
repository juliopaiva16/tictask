import 'package:file_selector/file_selector.dart';

/// Displays a system dialog for selecting where to save a file.
/// 
/// Parameters:
/// - [initialDirectory]: The directory to start in (optional)
/// - [suggestedName]: Default filename to suggest (optional)
/// - [acceptedTypeGroups]: List of file types that can be selected (optional)
/// 
/// Returns an XFile object if a location was selected, or null if canceled.
Future<XFile?> selectSaveLocation({
  String? initialDirectory,
  String? suggestedName,
  List<XTypeGroup>? acceptedTypeGroups,
}) async {
  try {
    // Get the save path using the file_selector package
    final FileSaveLocation? saveLocation = await getSaveLocation(
      initialDirectory: initialDirectory,
      suggestedName: suggestedName,
    );

    if (saveLocation == null) {
      return null; // User canceled the dialog
    }

    // Get the path from the save location
    final String path = saveLocation.path;
    
    return XFile(path);
  } catch (e) {
    print('Error showing save dialog: $e');
    return null;
  }
}