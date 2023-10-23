.PHONY: watch compile

ifeq ($(OS),Windows_NT)
    # Windows
    watch:
		@PowerShell -Command "typst watch AlexArgunov.typ --root ."

    compile:
		@PowerShell -Command "typst compile AlexArgunov.typ"
else
    # WSL or Unix-like system
    watch:
		@bash -c "typst watch AlexArgunov.typ --root ."

    compile:
		@bash -c "typst compile AlexArgunov.typ"
endif
