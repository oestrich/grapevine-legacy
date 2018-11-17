import "phoenix_html"
import Sizzle from "sizzle"

import "./chart"
import {Channels} from "./chat"

if (Sizzle(".chat").length > 0) {
  new Channels().join()
}
