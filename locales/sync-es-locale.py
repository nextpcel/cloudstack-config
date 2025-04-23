import json
from collections import OrderedDict


def update_translations():
    # Read English translations
    with open("en.json", "r", encoding="utf-8") as f:
        en_translations = json.load(f)

    # Read Spanish translations
    with open("es.json", "r", encoding="utf-8") as f:
        es_translations = json.load(f)

    # Find missing keys
    missing_keys = set(en_translations.keys()) - set(es_translations.keys())

    if not missing_keys:
        print("No missing translations found!")

    # Create a new ordered dictionary with the same order as en.json
    ordered_translations = OrderedDict()

    # First add all existing translations in the order of en.json
    for key in en_translations:
        if key in es_translations:
            ordered_translations[key] = es_translations[key]
        else:
            # Add missing keys with __FIXME__ value
            ordered_translations[key] = en_translations[key] + " __FIXME__"

    # Save updated Spanish translations
    with open("new_es.json", "w", encoding="utf-8") as f:
        json.dump(ordered_translations, f, ensure_ascii=False, indent=0)

    print(f"Added {len(missing_keys)} missing translations to es.json")


if __name__ == "__main__":
    update_translations()
