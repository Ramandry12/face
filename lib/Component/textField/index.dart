import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:face_recog_flutter/main.dart';
import 'package:fluttericon/fontelico_icons.dart';
import 'package:intl/intl.dart';

class TextFieldDefault extends StatelessWidget {
  final String? title;
  final String hintText;
  final bool isDark;
  final inputController;
  final inputType;
  final bool isObscure;
  final prefixIcon;
  final suffixIcon;
  final int maxLength;
  final int maxLines;
  final bool enabled;
  final itemList;
  final String? Function(dynamic)? validator;
  final onChanged;
  final selectedItem;
  final itemKey;
  final itemLabel;
  final TextCapitalization textCapital;

  const TextFieldDefault({
    Key? key,
    this.title = '',
    this.isObscure = false,
    required this.isDark,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    required this.inputController,
    this.inputType = TextInputType.text,
    this.maxLength = 12000,
    this.maxLines = 1,
    this.itemList,
    this.onChanged,
    this.selectedItem,
    this.itemKey,
    this.itemLabel,
    this.enabled = true,
    this.textCapital = TextCapitalization.none,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (inputType == "datePicker") {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != '')
            Text(
              title!,
              style:
                  Helpers.font1(14.0, isDark ? white : black, FontWeight.w400),
              maxLines: 4,
              textAlign: TextAlign.start,
            ),
          const SizedBox(
            height: defaultPadding / 2,
          ),
          ButtonPinch(
            scale: 0.95,
            boxColor: transparent,
            isShadow: false,
            isBorder: false,
            enable: true,
            paddingChild: const EdgeInsets.all(0.0),
            onPressed: () {},
            child: TextFormField(
              controller: inputController,
              keyboardType: TextInputType.none,
              enabled: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(100),
                  lastDate: DateTime(2100),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: basic, // header background color
                          onPrimary: white, // header text color
                          onSurface: black, // body text color
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: basicC, // button text color
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (pickedDate != null) {
                  inputController.text =
                      DateFormat('dd/MM/yyyy').format(pickedDate);
                }
              },
              decoration: InputDecoration(
                hintText: hintText,
                filled: true, // Set to true to enable background color
                fillColor: isDark ? textFieldDark : white,
                hintStyle:
                    isDark ? Helpers.styleHintDark() : Helpers.styleHint(),
                counterText: "",
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: isDark ? white : black),
                  borderRadius: BorderRadius.circular(defaultPadding),
                ),
              ),
              style: isDark ? Helpers.styleInputDark() : Helpers.styleInput(),
              validator: validator,
            ),
          ),
          const SizedBox(
            height: defaultPadding / 2,
          ),
        ],
      );
    }
    if (inputType == "dropDown") {
      var item = itemList ?? [];
      return ModalSearch(
        label: title,
        isDark: isDark,
        hintTitle: hintText,
        hintSearch: hintText,
        fit: FlexFit.loose,
        rightIcon: prefixIcon,
        items: item,
        onChanged: onChanged,
        selectedItem: selectedItem,
        showSearchBox: false,
        typePop: "menu",
        itemKey: itemKey,
        itemLabel: itemLabel,
        enableReset: false,
        validator: validator,
      );
    }
    else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != '')
            Text(
              title!,
              style: Helpers.font1(14.0, isDark ? white : black, FontWeight.w400),
              maxLines: 4,
              textAlign: TextAlign.start,
            ),
          const SizedBox(
            height: defaultPadding / 2,
          ),
          TextFormField(
            controller: inputController,
            keyboardType: inputType,
            obscureText: isObscure,
            maxLength: maxLength,
            maxLines: maxLines,
            enabled: enabled,
            onChanged: onChanged,
            textCapitalization: textCapital,
            decoration: InputDecoration(
              hintText: hintText,
              filled: true, // Set to true to enable background color
              fillColor: isDark ? textFieldDark : white,
              hintStyle: isDark ? Helpers.styleHintDark() : Helpers.styleHint(),
              counterText: "",
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: isDark ? white : gray),
                borderRadius: BorderRadius.circular(defaultPadding),
              ),
            ),
            style: isDark ? Helpers.styleInputDark() : Helpers.styleInput(),
            validator: validator,
          ),
          const SizedBox(
            height: defaultPadding / 2,
          ),
        ],
      );
    }
  }
}

class ModalSearch extends StatelessWidget {
  final List<dynamic> items;
  final Function(dynamic) onChanged;
  final dynamic selectedItem;
  final bool? enabled;
  final bool? showSearchBox;
  final FlexFit? fit;
  final bool? enableReset;
  final String? typePop;
  final String? itemKey;
  final String? itemLabel;
  final String hintTitle;
  final String? label;
  final Widget? rightIcon;
  final bool? isSpinner;
  final String? hintSearch;
  final bool isDark;
  final String? Function(dynamic)? validator;

  const ModalSearch({
    Key? key,
    required this.items,
    required this.onChanged,
    required this.isDark,
    this.selectedItem,
    this.enabled = true,
    this.showSearchBox = true,
    this.fit = FlexFit.tight,
    this.enableReset = true,
    this.typePop = "dialog", //bottom-menu-dialog
    this.itemKey,
    this.itemLabel,
    required this.hintTitle,
    this.hintSearch = "",
    this.label,
    this.rightIcon,
    this.isSpinner,
    this.validator,
  }) : super(key: key);

  void onChangedItem(e) {
    if (itemKey != null) {
      if (e == "") {
        onChanged("");
      } else {
        var onSelectedItem = Helpers.stringValidate(selectedItem);
        if (Helpers.stringValidate(e[itemKey]) != onSelectedItem) {
          onChanged(e[itemKey]);
        }
      }
    } else {
      var onSelectedItem = Helpers.stringValidate(selectedItem);
      if (Helpers.stringValidate(e) != onSelectedItem) {
        onChanged(e);
      }
    }
  }

  String validateSelected(e) {
    var onSelectedItem = Helpers.stringValidate(e);
    Map getLabel = {};
    if (onSelectedItem != "" && items.isNotEmpty) {
      getLabel = items.firstWhere((e) {
        return Helpers.stringValidate(e[itemKey]) == onSelectedItem;
      });
    }
    return getLabel.isEmpty ? "" : getLabel[itemLabel];
  }

  Widget itemBuilder(context, val, boolean) {
    final onSelectedItem = Helpers.stringValidate(selectedItem);
    var title = itemLabel == null
        ? Helpers.stringValidate(val)
        : Helpers.stringValidate(val[itemLabel]);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding * .65,
      ),
      child: Text(
        title,
        style: onSelectedItem == title
            ? Helpers.font1(14.0, basic, FontWeight.w600)
            : Helpers.styleInput(),
        textAlign: TextAlign.start,
      ),
    );
  }

  TextFieldProps onViewSearch() {
    return TextFieldProps(
      decoration: InputDecoration(
        hintText: hintSearch,
      ),
    );
  }

  ListViewProps listViewProps() {
    return const ListViewProps(
      padding: EdgeInsets.symmetric(vertical: defaultPadding * .35),
    );
  }

  PopupProps<Object?> onPopupProps() {
    if (typePop == "bottom") {
      return PopupProps.modalBottomSheet(
        itemBuilder: itemBuilder,
        showSearchBox: showSearchBox!,
        fit: fit!,
        searchDelay: const Duration(milliseconds: 400),
        searchFieldProps: onViewSearch(),
        modalBottomSheetProps: ModalBottomSheetProps(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide.none,
          ),
        ),
        listViewProps: listViewProps(),
      );
    } else if (typePop == "menu") {
      return PopupProps.menu(
        itemBuilder: itemBuilder,
        showSearchBox: showSearchBox!,
        fit: fit!,
        searchDelay: const Duration(milliseconds: 400),
        searchFieldProps: onViewSearch(),
        menuProps: MenuProps(
          borderRadius: Helpers.onRadius(1, 10.0),
        ),
        listViewProps: listViewProps(),
      );
    } else {
      return PopupProps.dialog(
        itemBuilder: itemBuilder,
        showSearchBox: showSearchBox!,
        fit: fit!,
        searchDelay: const Duration(milliseconds: 400),
        searchFieldProps: onViewSearch(),
        dialogProps: DialogProps(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide.none,
          ),
        ),
        listViewProps: listViewProps(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final onHintTitle = hintTitle;
    final onSelectedItem = Helpers.stringValidate(selectedItem);
    var onPrefixIcon = isSpinner == null
        ? rightIcon
        : isSpinner == true
            ? Icon(
                Fontelico.spin2,
                size: defaultSizeIcon,
                color: black.withOpacity(0.4),
              )
            : rightIcon;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Text(
              label!,
              style: Helpers.font1(14.0, isDark ? white : black, FontWeight.w400),
            ),
          ),
        if (label != null) const SizedBox(height: defaultPadding / 2),
        DropdownSearch<dynamic>(
          items: items,
          onChanged: onChangedItem,
          selectedItem: validateSelected(selectedItem),
          enabled: enabled!,
          dropdownBuilder: (context, val) {
            var title = Helpers.stringValidate(selectedItem);
            return Text(
              title == "" ? onHintTitle : validateSelected(title),
              style: title == ""
                  ? isDark
                      ? Helpers.styleHintDark()
                      : Helpers.styleHint()
                  : enabled!
                      ? isDark
                          ? Helpers.styleInputDark()
                          : Helpers.styleInput()
                      : Helpers.styleDisable(),
              textAlign: TextAlign.start,
            );
          },
          popupProps: onPopupProps(),
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              prefixIcon: onPrefixIcon,
              filled: true,
              fillColor: isDark ? textFieldDark : white,
              hintStyle: isDark ? Helpers.styleHintDark() : Helpers.styleHint(),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: isDark ? white : black),
                borderRadius: BorderRadius.circular(defaultPadding),
              ),
            ),
          ),
          dropdownButtonProps: !enableReset!
              ? const DropdownButtonProps()
              : onSelectedItem == ""
                  ? const DropdownButtonProps()
                  : DropdownButtonProps(
                      icon: Icon(
                        onSelectedItem == ""
                            ? Icons.arrow_drop_down
                            : Icons.clear,
                        size: 24,
                        color: black.withOpacity(0.4),
                      ),
                      onPressed: () {
                        if (onSelectedItem != "") {
                          onChangedItem("");
                        }
                      },
                    ),
          validator: validator,
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
      ],
    );
  }
}

class RadioButton extends StatelessWidget {
  final String label;
  final String groupValue;
  final String value;
  final Function(dynamic) onChanged;
  final EdgeInsets? padding;
  final double? sizeSpace;

  const RadioButton({
    Key? key,
    required this.label,
    required this.groupValue,
    required this.value,
    required this.onChanged,
    this.padding = const EdgeInsets.all(0.0),
    this.sizeSpace = 6.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (value != groupValue) onChanged(value);
      },
      child: Padding(
        padding: padding!,
        child: Wrap(
          direction: Axis.horizontal,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Radio<String>(
              groupValue: groupValue,
              value: value,
              onChanged: onChanged,
              activeColor: basic,
              visualDensity: const VisualDensity(
                horizontal: VisualDensity.minimumDensity,
                vertical: VisualDensity.minimumDensity,
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            SizedBox(width: sizeSpace!),
            Text(
              label,
              style: Helpers.styleInput(),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
