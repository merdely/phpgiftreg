/*!
 * Color mode toggler for Bootstrap's docs (https://getbootstrap.com/)
 * Copyright 2011-2024 The Bootstrap Authors
 * Licensed under the Creative Commons Attribution 3.0 Unported License.
 */

// Downloaded from https://getbootstrap.com/docs/5.3/assets/js/color-modes.js

(() => {
  'use strict'

  const getStoredTheme = () => localStorage.getItem('theme')
  const setStoredTheme = theme => localStorage.setItem('theme', theme)

  const getPreferredTheme = () => {
    const storedTheme = getStoredTheme()
    if (storedTheme) {
      return storedTheme
    }

    return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light'
  }

  const setTheme = theme => {
    if (theme === 'auto') {
      document.documentElement.setAttribute('data-bs-theme', (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light'))
    } else {
      document.documentElement.setAttribute('data-bs-theme', theme)
    }
  }

  setTheme(getPreferredTheme())

  const showActiveTheme = (theme, focus = false) => {
    const themeSwitcher = document.querySelector('#bd-theme')

    if (!themeSwitcher) {
      return
    }

    document.querySelectorAll('[data-bs-theme-value]').forEach(element => {
      element.classList.remove('active')
      element.setAttribute('aria-pressed', 'false')
    })

    // Changes by github.com/merdely: change theme images throughout page
    document.querySelectorAll('.theme-image').forEach(function(image) {
      image.src = image.getAttribute('data-' +
        document.documentElement.getAttribute('data-bs-theme')
        + '-src');
    });

    // Changes by github.com/merdely: use img instead of svg
    document.querySelectorAll('.theme-image-active').forEach(function(image) {
      image.src = image.getAttribute('data-' + theme + '-' +
        document.documentElement.getAttribute('data-bs-theme')
        + '-src');
    });
    document.querySelectorAll('.theme-image-check').forEach(function(image) {
      // image.parentElement.classList.remove('active');
      // image.parentElement.setAttribute('aria-pressed', 'false');
      image.classList.add('d-none');
    });
    document.querySelectorAll(`#theme-${theme}`).forEach(function(image) {
      // image.parentElement.classList.add('active');
      // image.parentElement.setAttribute('aria-pressed', 'true');
      image.classList.remove('d-none');
    });

    if (focus) {
      themeSwitcher.focus()
    }
  }

  window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', () => {
    const storedTheme = getStoredTheme()
    if (storedTheme !== 'light' && storedTheme !== 'dark') {
      setTheme(getPreferredTheme());
      showActiveTheme(getPreferredTheme());
    }
  })

  window.addEventListener('DOMContentLoaded', () => {
    showActiveTheme(getPreferredTheme())

    document.querySelectorAll('[data-bs-theme-value]')
      .forEach(toggle => {
        toggle.addEventListener('click', () => {
          const theme = toggle.getAttribute('data-bs-theme-value')
          setStoredTheme(theme)
          setTheme(theme)
          showActiveTheme(theme, true)
        })
      })
  })
})()
