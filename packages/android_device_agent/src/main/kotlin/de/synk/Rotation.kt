package de.synk

import android.os.IBinder
import java.lang.reflect.Method

private const val DEFAULT_DISPLAY = 0
private const val CALLER = "synk"
private val INT = Int::class.java
private val STRING = String::class.java

object Rotation {
    private val windowManager: Any by lazy {
        val binder = Class.forName("android.os.ServiceManager")
            .getMethod("getService", String::class.java)
            .invoke(null, "window") as IBinder

        Class.forName("android.view.IWindowManager\$Stub")
            .getMethod("asInterface", IBinder::class.java)
            .invoke(null, binder)!!
    }

    private var wasFrozenBeforeLock: Boolean? = null

    fun lock(rotation: Int) {
        if (wasFrozenBeforeLock == null) {
            wasFrozenBeforeLock = isFrozen()
        }

        freeze(rotation)
    }

    fun restore() {
        val wasFrozen = wasFrozenBeforeLock ?: return
        wasFrozenBeforeLock = null

        if (!wasFrozen) {
            thaw()
        }
    }

    private fun isFrozen(): Boolean {
        return method("isDisplayRotationFrozen", INT)
            ?.invoke(windowManager, DEFAULT_DISPLAY) as Boolean?
            ?: method("isRotationFrozen")!!.invoke(windowManager) as Boolean
    }

    private fun freeze(rotation: Int) {
        method("freezeDisplayRotation", INT, INT, STRING)
            ?.let { it.invoke(windowManager, DEFAULT_DISPLAY, rotation, CALLER); return }
        method("freezeDisplayRotation", INT, INT)
            ?.let { it.invoke(windowManager, DEFAULT_DISPLAY, rotation); return }
        method("freezeRotation", INT, STRING)
            ?.let { it.invoke(windowManager, rotation, CALLER); return }
        method("freezeRotation", INT)!!.invoke(windowManager, rotation)
    }

    private fun thaw() {
        method("thawDisplayRotation", INT, STRING)
            ?.let { it.invoke(windowManager, DEFAULT_DISPLAY, CALLER); return }
        method("thawDisplayRotation", INT)
            ?.let { it.invoke(windowManager, DEFAULT_DISPLAY); return }
        method("thawRotation", STRING)
            ?.let { it.invoke(windowManager, CALLER); return }
        method("thawRotation")!!.invoke(windowManager)
    }

    private fun method(name: String, vararg parameterTypes: Class<*>): Method? {
        return try {
            windowManager.javaClass.getMethod(name, *parameterTypes)
        } catch (e: NoSuchMethodException) {
            null
        }
    }
}
