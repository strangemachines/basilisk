import "phoenix_html"
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}})

topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

liveSocket.connect()

window.liveSocket = liveSocket


document.querySelectorAll('.nav-toggle')
  .forEach((element) => {
    element.addEventListener('click', () => {
      document.querySelectorAll('.nav-content').forEach((item) => {
        item.classList.toggle('hidden');
      });
    });
  });


document.querySelectorAll('.dropdown-toggle')
  .forEach((element) => {
    element.addEventListener('click', () => {
      document.querySelectorAll('.dropdown-content').forEach((item) => {
        item.classList.toggle('open');

        element.addEventListener('blur', () => {
          setTimeout(() => {
            item.classList.remove('open')
          }, 150);

        })
      });
    });
  });


window.addEventListener("phx:js-exec", ({ detail }) => {
  document.querySelectorAll(detail.to).forEach(el => {
    liveSocket.execJS(el, el.getAttribute(detail.attr))
  })
});