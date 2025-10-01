import tkinter as tk
from tkinter import ttk


class CalculadoraGUI:
    """Calculadora básica con interfaz gráfica usando Tkinter."""

    def __init__(self, master: tk.Tk) -> None:
        self.master = master
        self.master.title("Calculadora")
        self.master.resizable(False, False)

        self.valor_actual = tk.StringVar(value="")

        self._crear_widgets()

    def _crear_widgets(self) -> None:
        """Configura los widgets principales de la calculadora."""
        estilo = ttk.Style()
        estilo.configure("TButton", padding=6)

        entrada = ttk.Entry(
            self.master,
            textvariable=self.valor_actual,
            font=("Helvetica", 18),
            justify="right",
            width=20,
        )
        entrada.grid(row=0, column=0, columnspan=4, padx=10, pady=10)

        botones = [
            ("7", 1, 0),
            ("8", 1, 1),
            ("9", 1, 2),
            ("/", 1, 3),
            ("4", 2, 0),
            ("5", 2, 1),
            ("6", 2, 2),
            ("*", 2, 3),
            ("1", 3, 0),
            ("2", 3, 1),
            ("3", 3, 2),
            ("-", 3, 3),
            ("0", 4, 0),
            (".", 4, 1),
            ("C", 4, 2),
            ("+", 4, 3),
            ("=", 5, 0, 4),
        ]

        for boton in botones:
            texto, fila, columna = boton[:3]
            colspan = boton[3] if len(boton) == 4 else 1
            ttk.Button(
                self.master,
                text=texto,
                command=lambda valor=texto: self._manejar_boton(valor),
            ).grid(row=fila, column=columna, columnspan=colspan, sticky="nsew", padx=5, pady=5)

        for i in range(4):
            self.master.grid_columnconfigure(i, weight=1)
        self.master.grid_rowconfigure(5, weight=1)

    def _manejar_boton(self, valor: str) -> None:
        """Determina la acción a realizar según el botón pulsado."""
        if valor == "C":
            self.valor_actual.set("")
        elif valor == "=":
            self._calcular_resultado()
        else:
            self.valor_actual.set(self.valor_actual.get() + valor)

    def _calcular_resultado(self) -> None:
        """Evalúa la expresión actual y muestra el resultado."""
        expresion = self.valor_actual.get()
        try:
            resultado = eval(expresion, {"__builtins__": {}}, {})
        except Exception:
            self.valor_actual.set("Error")
        else:
            self.valor_actual.set(str(resultado))


def main() -> None:
    raiz = tk.Tk()
    CalculadoraGUI(raiz)
    raiz.mainloop()


if __name__ == "__main__":
    main()
