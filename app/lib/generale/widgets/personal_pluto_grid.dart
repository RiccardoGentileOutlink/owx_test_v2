import 'package:flutter/material.dart';
import 'package:ows_test_v2/utility.dart';
import 'package:pluto_grid/pluto_grid.dart';

class PersonalPlutoGrid extends StatelessWidget {
  final PlutoGridMode mode;
  final List<PlutoColumn> colonne;
  final List<PlutoRow> righe;
  final bool mostraFiltri;
  final int pageSize;
  final PlutoAutoSizeMode autoSize;
  final Function(PlutoGridOnRowCheckedEvent)? setOnRowChecked;
  final Function(PlutoGridStateManager)? setPlutoGridStateManager;

  const PersonalPlutoGrid(
      {this.mode = PlutoGridMode.readOnly,
      required this.colonne,
      required this.righe,
      this.mostraFiltri = true,
      this.pageSize = 0,
      this.setPlutoGridStateManager,
      this.setOnRowChecked,
      this.autoSize = PlutoAutoSizeMode.scale,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(inputDecorationTheme: const InputDecorationTheme(isDense: false)),
      child: PlutoGrid(
        columns: colonne,
        rows: righe,
        mode: mode,
        onLoaded: (PlutoGridOnLoadedEvent event) {
          event.stateManager.setShowColumnFilter(mostraFiltri);
          if (setPlutoGridStateManager != null) {
            setPlutoGridStateManager!(event.stateManager);
          }
        },
        onRowChecked: (event) {
          if (setOnRowChecked != null) {
            setOnRowChecked!(event);
          }
        },
        configuration: PlutoGridConfiguration(
            style: PlutoGridStyleConfig(
              evenRowColor: Theme.of(context).secondaryHeaderColor,
              gridBorderColor: Theme.of(context).secondaryHeaderColor,
              gridBorderRadius: const BorderRadius.all(Radius.circular(5)),
              gridPopupBorderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            scrollbar: const PlutoGridScrollbarConfig(scrollbarThickness: ValoriDefault.defaultPadding),
            columnSize: PlutoGridColumnSizeConfig(autoSizeMode: autoSize),
            columnFilter: const PlutoGridColumnFilterConfig(
              filters: FilterHelper.defaultFilters,
            ),
            localeText: getPlutoItalianLocaleText(Utility.getLingua())),
        createFooter: pageSize != 0
            ? (stateManager) {
                stateManager.setPageSize(pageSize, notify: false);
                return PlutoPagination(
                  stateManager,
                  pageSizeToMove: 1,
                );
              }
            : null,
        /* createHeader: (stateManager) {
          return ElevatedButton(
              onPressed: () {
                
              },
              child: const Text("Esporta in excel"));
        },*/
      ),
    );
  }

  static PlutoGridLocaleText getPlutoItalianLocaleText(String lingua) {
    if (lingua == "it") {
      return const PlutoGridLocaleText(
          autoFitColumn: 'Auto-fit',
          filterColumn: 'Colonna',
          filterAllColumns: 'Tutte le colonne',
          filterContains: 'Contiene',
          filterEndsWith: 'Termina per',
          filterEquals: 'Uguale',
          filterGreaterThan: 'Maggiore di',
          filterGreaterThanOrEqualTo: 'Maggiore o uguale a',
          filterLessThan: 'Minore di',
          filterLessThanOrEqualTo: 'Minore o uguale a',
          filterStartsWith: 'Inizia per',
          filterType: 'Tipo',
          filterValue: 'Valore',
          freezeColumnToEnd: 'Blocca alla fine',
          freezeColumnToStart: 'Blocca all\'inizio',
          friday: 'Ven',
          hideColumn: 'Nascondi colonna',
          hour: 'Ora',
          loadingText: 'Caricamento...',
          minute: 'Minuto',
          monday: 'Lun',
          resetFilter: 'Resetta flitri',
          saturday: 'Sab',
          setColumns: 'Imposta colonne',
          setColumnsTitle: 'Imposta titoli colonne',
          setFilter: 'Imposta filtri',
          sunday: 'Dom',
          thursday: 'Gio',
          tuesday: 'Mar',
          unfreezeColumn: 'Sblocca colonna',
          wednesday: 'Mer');
    } else {
      return const PlutoGridLocaleText();
    }
  }
}
