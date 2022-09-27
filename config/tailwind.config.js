const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        "pt-serif": ["PT Serif", "serif"],
        montserrat: ["Montserrat", "sans-serif"],
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      backgroundImage: {
        underline1: "url('Underline1.svg')",
        underline2: "url('Underline2.svg')",
        underline3: "url('Underline3.svg')",
        underline4: "url('Underline4.svg')",
        highlight3: "url('Highlight3.svg')",
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
  ]
}
